{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  server = config.syde.server;
  email = config.syde.email;

  cfg = config.services.nextcloud;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets = {
      nextcloudAdminPassword = {
        file = ../../secrets/nextcloudAdminPassword.age;
      };
      nextcloudSecretFile = {
        file = ../../secrets/nextcloudSecretFile.age;
        owner = "nextcloud";
        group = "nextcloud";
      };
    };

    services = {
      nginx = {
        virtualHosts."${cfg.hostName}" = {
          locations."^~ /push/".extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
      };

      nextcloud = {
        package = pkgs.nextcloud31;
        hostName = "cloud.${server.baseDomain}";
        datadir = "/mnt/tank/nextcloud";
        database.createLocally = true;
        secretFile = config.age.secrets.nextcloudSecretFile.path;

        configureRedis = true;
        caching.redis = true;
        https = true;

        notify_push = {
          enable = true;
          bendDomainToLocalhost = true;
        };

        maxUploadSize = "50G";

        appstoreEnable = true;
        autoUpdateApps.enable = true;
        extraAppsEnable = true;
        extraApps = {
          inherit (cfg.package.packages.apps)
            bookmarks
            calendar
            collectives
            contacts
            cookbook
            files_mindmap
            groupfolders
            maps
            memories
            music
            notes
            notify_push
            recognize
            richdocuments
            tasks
            ;
        };

        settings = {
          overwriteprotocol = "https";
          overwritehost = "cloud.${server.baseDomain}";
          overwrite.cli.url = "https://cloud.${server.baseDomain}";

          mail_smtpmode = "smtp";
          mail_smtphost = email.smtpServer;
          mail_smtpauth = true;
          mail_smtpport = 587;
          mail_from_address = "s"
          mail_domain = server.baseDomain;

          user_oidc = {
            allow_multiple_user_backends = 0;
          };

          forwarded_for_headers = [
            "HTTP_X_FORWARDED_FOR"
          ];

          enabledPreviewProviders = [
            "OC\\Preview\\BMP"
            "OC\\Preview\\GIF"
            "OC\\Preview\\JPEG"
            "OC\\Preview\\Krita"
            "OC\\Preview\\MarkDown"
            "OC\\Preview\\MP3"
            "OC\\Preview\\OpenDocument"
            "OC\\Preview\\PNG"
            "OC\\Preview\\TXT"
            "OC\\Preview\\XBitmap"
            "OC\\Preview\\HEIC"
          ];
        };

        config = {
          dbtype = "pgsql";
          adminuser = username;
          adminpassFile = config.age.secrets.nextcloudAdminPassword.path;
        };
      };
    };
  };
}

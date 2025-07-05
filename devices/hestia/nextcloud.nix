{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  server = config.syde.server;

  cfg = config.services.nextcloud;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets.nextcloudAdminPassword = {
      file = ../../secrets/nextcloudAdminPassword.age;
    };

    services = {
      nginx = {
        virtualHosts."${cfg.hostName}" = { };
      };

      postgresql = {
        ensureDatabases = [ "nextcloud" ];
        ensureUsers = [
          {
            name = "nextcloud";
            ensureDBOwnership = true;
          }
        ];
      };

      nextcloud = {
        package = pkgs.nextcloud31;
        hostName = "cloud.${server.baseDomain}";
        datadir = "/mnt/tank/nextcloud";

        configureRedis = true;
        caching.redis = true;

        maxUploadSize = "50G";

        extraApps = {
          inherit (cfg.package.packages.apps) contacts calendar;
        };
        extraAppsEnable = true;

        settings = {
          trusted_proxies = [ "127.0.0.1" ];
          overwriteprotocol = "https";
          overwritehost = "cloud.${server.baseDomain}";
          overwrite.cli.url = "https://cloud.${server.baseDomain}";
          mail_smtpmode = "sendmail";
          mail_sendmailmode = "pipe";

          user_oidc = {
            allow_multiple_user_backends = 0;
          };

          forwarded_for_headers = [
            "HTTP_CF_CONNECTING_IP"
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
          dbuser = "nextcloud";
          dbhost = "/run/postgresql";
          dbname = "nextcloud";
          adminuser = username;
          adminpassFile = config.age.secrets.nextcloudAdminPassword.path;
        };
      };
    };

    systemd.services."nextcloud-setup" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
  };
}

{
  config,
  pkgs,
  lib,
  username,
  inputs,
  ...
}:
let
  inherit (lib) mkIf getExe head splitString;
  inherit (config.syde) server email;

  cfg = config.services.nextcloud;
in
{
  config = mkIf cfg.enable {
    age.secrets = {
      nextcloudAdminPassword = {
        file = "${inputs.secrets}/nextcloudAdminPassword.age";
      };
      nextcloudSecretFile = {
        file = "${inputs.secrets}/nextcloudSecretFile.age";
        owner = "nextcloud";
        group = "nextcloud";
      };
    };

    users.users.nextcloud.extraGroups = [
      "render"
      "video"
      server.group
    ];

    environment.systemPackages = [ pkgs.perl ];

    services = {
      nginx = {
        virtualHosts."${cfg.hostName}" = {
          locations."^~ /push/".extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };

        upstreams.collabora.servers."127.0.0.1:${toString config.services.collabora-online.port}" = { };

        virtualHosts."docs.${server.baseDomain}" = {
          locations = {
            "^~ /browser" = {
              proxyPass = "http://collabora";
              proxyWebsockets = true;
              extraConfig = ''
                add_header Alt-Svc 'h3=":$server_port"; ma=86400';
              '';
            };

            "^~ /hosting/discovery" = {
              proxyPass = "http://collabora";
              proxyWebsockets = true;
              extraConfig = ''
                add_header Alt-Svc 'h3=":$server_port"; ma=86400';
              '';
            };

            "^~ /hosting/capabilities" = {
              proxyPass = "http://collabora";
              proxyWebsockets = true;
              extraConfig = ''
                add_header Alt-Svc 'h3=":$server_port"; ma=86400';
              '';
            };

            "~ ^/cool/(.*)/ws$" = {
              proxyPass = "http://collabora";
              proxyWebsockets = true;
              extraConfig = ''
                add_header Alt-Svc 'h3=":$server_port"; ma=86400';
              '';
            };

            "~ ^/(c|l)ool" = {
              proxyPass = "http://collabora";
              proxyWebsockets = true;
              extraConfig = ''
                add_header Alt-Svc 'h3=":$server_port"; ma=86400';
              '';
            };

            "^~ /cool/adminws" = {
              proxyPass = "http://collabora";
              proxyWebsockets = true;
              extraConfig = ''
                add_header Alt-Svc 'h3=":$server_port"; ma=86400';
              '';
            };
          };
        };
      };

      collabora-online = {
        enable = true;
        settings = {
          net.post_allow.host = [
            "cloud.${server.baseDomain}"
          ];
          ssl = {
            enable = false;
            termination = true;
          };
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

        maxUploadSize = "24G";

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
            previewgenerator
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
          mail_from_address = head (splitString "@" email.fromAddress);
          mail_domain = server.baseDomain;

          default_phone_region = "DK";

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

          "memories.exiftool" = "${getExe pkgs.exiftool}";
          "memories.vod.ffmpeg" = "${pkgs.ffmpeg-headless}/bin/ffmpeg";
          "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";
          preview_ffmpeg_path = "${pkgs.ffmpeg-headless}/bin/ffmpeg";
        };

        config = {
          dbtype = "pgsql";
          adminuser = username;
          adminpassFile = config.age.secrets.nextcloudAdminPassword.path;
        };
      };

      postgresql.enable = true;
    };

    syde.services.fail2ban.jails.nextcloud = {
      serviceName = "phpfpm-nextcloud";
      failRegex = "^.*Login failed:.*(Remote IP: <HOST>).*$";
    };

    systemd.services.nextcloud-cron = {
      path = [pkgs.perl];
    };
  };
}

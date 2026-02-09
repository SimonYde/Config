{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkForce;
  inherit (config.syde) server email;
  cfg = config.services.immich;
in
{

  options.services.immich = {
    mediaDir = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.immichClientSecret = {
      file = "${inputs.secrets}/immichClientSecret.age";
      owner = "immich";
    };
    systemd.tmpfiles.rules = [ "d ${cfg.mediaDir} 0775 immich ${server.group} - -" ];

    users.users.immich.extraGroups = [
      "video"
      "render"
    ];

    networking.hosts = {
      "127.0.0.1" = [
        "foto.${server.baseDomain}"
      ];
      "::1" = [
        "foto.${server.baseDomain}"
      ];
    };

    services = {
      immich = {
        inherit (server) group;

        # Use available acceleration devices, added to group above
        accelerationDevices = [
          "/dev/dri/card0"
          "/dev/dri/renderD128"
        ];

        database = {
          enableVectors = false;
          enableVectorChord = true;
        };

        port = 2283;
        mediaLocation = "${cfg.mediaDir}";

        settings = {
          oauth = {
            enabled = true;
            autoLaunch = true;
            autoRegister = true;
            clientId = "immich";
            roleClaim = "immich_role";
            scope = "openid email profile immich_role";
            buttonText = "Login with Kanidm";
            issuerUrl = "https://auth.simonyde.com/oauth2/openid/immich";
            signingAlgorithm = "ES256";
            clientSecret._secret = config.age.secrets.immichClientSecret.path;
          };
          passwordLogin.enabled = false;
          notifications = {
            smtp = {
              enabled = email.enable;
              from = "Immich <${email.fromAddress}>";
              transport = {
                host = email.smtpServer;
                ignoreCert = false;
                password._secret = email.smtpPasswordPath;
                port = email.smtpPort;
                secure = true;
                username = email.smtpUsername;
              };
            };
          };
          storageTemplate = {
            enabled = true;
            hashVerificationEnabled = true;
            template = "{{y}}/{{#if album}}{{album}}{{else}}{{yy}}{{MM}}{{dd}} - andet{{/if}}/{{filename}}";
          };
        };
      };

      nginx = {
        upstreams.immich.servers."${cfg.host}:${toString cfg.port}" = { };

        virtualHosts."foto.${server.baseDomain}" = {
          locations."/" = {
            proxyPass = "http://immich";
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 50000M;
              proxy_read_timeout   600s;
              proxy_send_timeout   600s;
              send_timeout         600s;
            '';
          };
        };
      };
    };
  };
}

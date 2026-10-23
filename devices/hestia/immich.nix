{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  inherit (config.syde) server email;
  inherit (server) baseDomain internalDomain;

  hostName = "foto.${baseDomain}";
  cfg = config.services.immich;
in
{

  options.services.immich = {
    mediaDir = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
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
      "127.0.0.1" = [ hostName ];
      "::1" = [ hostName ];
    };

    services = {
      immich = {
        inherit (server) group;

        # Use available acceleration devices, added to group above
        accelerationDevices = [
          "/dev/dri/card0"
          "/dev/dri/renderD128"
        ];

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
            issuerUrl = "https://${server.authDomain}/oauth2/openid/immich";
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

        virtualHosts = {
          "foto.${internalDomain}" = {
            isInternal = true;

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



          ${hostName} = {
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
  };
}

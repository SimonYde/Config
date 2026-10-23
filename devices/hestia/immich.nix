{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  inherit (config.syde) server email;
  inherit (server) baseDomain internalDomain;

  hostName = "foto.${baseDomain}";
  ippHostName = "share.${baseDomain}";
  ippPort = 2288;
  ippUploadPort = 2289;
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

    # Without this IPP builds link-preview URLs from the plain HTTP request
    # that nginx forwards, producing http:// instead of https://.
    systemd.services.immich-public-proxy.environment.PUBLIC_BASE_URL = "https://${ippHostName}";

    # Optional visitor-upload container. It is intentionally a separate
    # service: IPP itself stays read-only and cannot accept files.
    systemd.services.immich-public-proxy-upload = {
      description = "Visitor upload service for Immich Public Proxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        IMMICH_URL = "http://127.0.0.1:2283";
        IPP_PORT = toString ippUploadPort;
        PUBLIC_BASE_URL = "https://${ippHostName}";
        IPP_CONFIG = config.systemd.services.immich-public-proxy.environment.IPP_CONFIG;
        NODE_ENV = "production";
      };

      serviceConfig = {
        ExecStart = "${pkgs.immich-public-proxy-upload}/bin/immich-public-proxy-upload";
        User = "ipp-upload";
        Group = "ipp-upload";
        DynamicUser = true;
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;

        # Hardening, matching the upstream IPP service.
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
      };
    };

    services = {
      immich = {
        inherit (server) group;

        # Use available acceleration devices, added to group above
        accelerationDevices = [
          "/dev/dri/card0"
          "/dev/dri/renderD128"
        ];

        host = "127.0.0.1";
        port = 2283;
        mediaLocation = "${cfg.mediaDir}";

        settings = {
          # Uncomment to make Immich generate IPP share links. While IPP is
          # internal-only, those links only work on the tailnet.
          server.externalDomain = "https://${ippHostName}";

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

      immich-public-proxy = {
        enable = true;
        package = pkgs.immich-public-proxy;
        # IPP must reach Immich over the local interface, not through the
        # public nginx vhost (which would also mean a round-trip through TLS).
        immichUrl = "http://127.0.0.1:2283";
        port = ippPort;

        settings.ipp.uploadUrl = "/upload";
      };

      nginx = {
        upstreams.immich.servers."${cfg.host}:${toString cfg.port}" = { };
        upstreams.immich-public-proxy.servers."127.0.0.1:${toString ippPort}" = { };
        upstreams.immich-public-proxy-upload.servers."127.0.0.1:${toString ippUploadPort}" = { };

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

          # Internal-only for now, so shares are only reachable over the
          # tailnet. To expose shares publicly later, add a non-internal vhost
          # (e.g. share.${baseDomain}) pointing at the same upstream and update
          # services.immich.settings.server.externalDomain to that URL.
          "${ippHostName}" = {
            locations = {
              # Preserve the /upload prefix: the upload service serves its
              # pages both under /upload and at the root. No trailing slash
              # on proxyPass, or nginx strips the prefix.
              "/upload/" = {
                proxyPass = "http://immich-public-proxy-upload";
                extraConfig = ''
                  client_max_body_size 512M;
                  proxy_request_buffering off;
                  proxy_read_timeout   600s;
                  proxy_send_timeout   600s;
                  send_timeout         600s;
                '';
              };

              "/" = {
                proxyPass = "http://immich-public-proxy";
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

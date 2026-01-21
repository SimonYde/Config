{ config, lib, ... }:
let
  cfg = config.services.opencloud;
  inherit (config.syde) server;
  inherit (lib) mkIf mkDefault mkForce;
in
{
  config = mkIf cfg.enable {
    services = {
      opencloud = {
        stateDir = mkDefault (throw "Please specify opencloud stateDir");

        environment = {
          OC_URL = "https://opencloud.ts.simonyde.com";
          OC_OIDC_ISSUER = "https://auth.simonyde.com/oauth2/openid/opencloud";
          OC_OIDC_CLIENT_ID = "opencloud";
          OC_EXCLUDE_RUN_SERVICES = "idp";
          PROXY_TLS = "false";
        };

        settings = {
          proxy = {
            auto_provision_accounts = true;
            auto_provision_claims.groups = "not-a-real-claim";
            oidc.rewrite_well_known = true;
            role_assignment = {
              driver = "oidc";
              oidc_role_mapper = {
                role_claim = "groups";
                role_mapping = [
                  {
                    role_name = "admin";
                    claim_value = "oc_admins@auth.simonyde.com";
                  }
                  {
                    role_name = "user";
                    claim_value = "oc_users@auth.simonyde.com";
                  }
                  {
                    role_name = "guest";
                    claim_value = "oc_guests@auth.simonyde.com";
                  }
                ];
              };
            };
            csp_config_file_location = "/etc/opencloud/csp.yaml";
          };
          csp = {
            directives = {
              child-src = [
                "'self'"
              ];
              connect-src = [
                "'self'"
                "blob:"
                "https://auth.simonyde.com/"
                "https://raw.githubusercontent.com/opencloud-eu/awesome-apps/"
              ];
              default-src = [
                "'none'"
              ];
              font-src = [
                "'self'"
              ];
              frame-ancestors = [
                "'self'"
              ];
              frame-src = [
                "'self'"
                "blob:"
                "https://embed.diagrams.net/"
              ];
              img-src = [
                "'self'"
                "data:"
                "blob:"
                "https://raw.githubusercontent.com/opencloud-eu/awesome-apps/"
              ];
              manifest-src = [
                "'self'"
              ];
              media-src = [
                "'self'"
              ];
              object-src = [
                "'self'"
                "blob:"
              ];
              script-src = [
                "'self'"
                "'unsafe-inline'"
              ];
              style-src = [
                "'self'"
                "'unsafe-inline'"
              ];
            };
          };
          graph.api = {
            graph_assign_default_user_role = false;
            graph_username_match = "none";
          };
          web.web.config.oidc.scope = "openid profile email groups";

          collaboration = {
            app = {
              name = "Collabora";
              product = "";
              description = "Open office documents with Collabora";
              icon = "image-edit";
              addr = "https://docs.${server.baseDomain}";
              insecure = false;
              proofkeys = {
                disable = false;
                duration = "12h";
              };
              licensecheckenable = false;
            };
            wopi.wopisrc = "https://docs.${server.baseDomain}";
          };
        };
      };

      nginx = {
        upstreams.opencloud.servers."127.0.0.1:9200" = { };

        virtualHosts."opencloud.ts.simonyde.com" = {
          acmeRoot = mkForce null;
          enableACME = mkForce false;
          useACMEHost = "ts.simonyde.com";

          locations."/" = {
            proxyPass = "http://opencloud";
            proxyWebsockets = true;
          };
        };
      };
    };

    systemd.services =
      let
        environment = {
          PROXY_HTTP_ADDR = "${cfg.address}:${toString cfg.port}";
          OC_URL = cfg.url;
          OC_BASE_DATA_PATH = cfg.stateDir;
          WEB_ASSET_CORE_PATH = "${cfg.webPackage}";
          IDP_ASSET_PATH = "${cfg.idpWebPackage}/assets";
          OC_CONFIG_DIR = "/etc/opencloud";
        }
        // cfg.environment;
        commonServiceConfig = {
          EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectKernelLogs = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          LockPersonality = true;
          SystemCallArchitectures = "native";
        };
      in
      {
        opencloud-collaboration = {
          description = "OpenCloud Collaboration - connects opencloud with document servers such as Collabora, ONLYOFFICE or Microsoft using the WOPI protocol.";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          inherit environment;

          serviceConfig = {
            Type = "simple";
            ExecStart = "${lib.getExe cfg.package} collaboration server";
            WorkingDirectory = cfg.stateDir;
            User = cfg.user;
            Group = cfg.group;
            Restart = "always";
            ReadWritePaths = [ cfg.stateDir ];
          }
          // commonServiceConfig;

          restartTriggers = lib.mapAttrsToList (
            name: _: config.environment.etc."opencloud/${name}.yaml".source
          ) cfg.settings;
        };
      };
  };
}

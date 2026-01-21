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
          OC_LOG_LEVEL = "warn";
          OC_OIDC_ISSUER = "https://auth.simonyde.com/oauth2/openid/opencloud";
          OC_OIDC_CLIENT_ID = "opencloud";
          OC_EXCLUDE_RUN_SERVICES = "idp";
          OC_ADD_RUN_SERVICES = "collaboration";
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
                "https://docs.${server.baseDomain}/"
              ];
              frame-src = [
                "'self'"
                "blob:"
                "https://embed.diagrams.net/"
                "https://docs.${server.baseDomain}/"
              ];
              img-src = [
                "'self'"
                "data:"
                "blob:"
                "https://docs.${server.baseDomain}/"
                "https://tile.openstreetmap.org/"
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
              product = "Collabora";
              icon = "https://docs.tmcs.dk/favicon.ico";
              addr = "https://docs.tmcs.dk";
              insecure = true;
              proofkeys = {
                disable = false;
                duration = "12h";
              };
              licensecheckenable = false;
            };
            wopi.wopisrc = "https://wopi.ts.simonyde.com";
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

        upstreams.wopi.servers."127.0.0.1:9300" = { };

        virtualHosts."wopi.ts.simonyde.com" = {
          acmeRoot = mkForce null;
          enableACME = mkForce false;
          useACMEHost = "ts.simonyde.com";

          locations."/" = {
            proxyPass = "http://wopi";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}

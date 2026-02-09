{ config, lib, ... }:
let
  cfg = config.services.opencloud;
  inherit (config.syde) server;
  inherit (lib) mkIf mkForce;
in
{
  config = mkIf cfg.enable {
    services = {
      opencloud = {
        url = "https://opencloud.ts.simonyde.com";

        environment = {
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
              icon = "https://docs.${server.baseDomain}/favicon.ico";
              addr = "https://docs.${server.baseDomain}";
              insecure = false;
              proofkeys = {
                disable = false;
                duration = "12h";
              };
              licensecheckenable = false;
            };
            wopi.wopisrc = "http://127.0.0.1:9300";
          };
        };
      };

      radicale = {
        enable = true;
        settings = {
          server = {
            hosts = [ "127.0.0.1:5232" ];
            ssl = false; # disable SSL, only use when behind reverse proxy
          };
          auth = {
            type = "http_x_remote_user"; # disable authentication, and use the username that OpenCloud provides is
          };
          web = {
            type = "none";
          };
          storage = {
            filesystem_folder = "/var/lib/radicale/collections";
          };
          logging = {
            level = "debug"; # optional, enable debug logging
            bad_put_request_content = true; # only if level=debug
            request_header_on_debug = true; # only if level=debug
            request_content_on_debug = true; # only if level=debug
            response_content_on_debug = true; # only if level=debug
          };
        };
      };

      nginx = {
        upstreams = {
          opencloud.servers."127.0.0.1:9200" = { };
          radicale.servers."127.0.0.1:5232" = { };
        };

        virtualHosts."opencloud.ts.simonyde.com" = {
          acmeRoot = mkForce null;
          enableACME = mkForce false;
          useACMEHost = "ts.simonyde.com";

          locations = {
            "/" = {
              proxyPass = "http://opencloud";
              proxyWebsockets = true;
            };

            # Radicale endpoints for CalDAV and CardDAV
            "/caldav/" = {
              proxyPass = "http://radicale";
              extraConfig = ''
                proxy_set_header X-Remote-User $remote_user; # provide username to CalDAV
                proxy_set_header X-Script-Name /caldav;
              '';
            };
            "/.well-known/caldav" = {
              proxyPass = "http://radicale";
              extraConfig = ''
                proxy_set_header X-Remote-User $remote_user; # provide username to CalDAV
                proxy_set_header X-Script-Name /caldav;
              '';
            };
            "/carddav/" = {
              proxyPass = "http://radicale";
              extraConfig = ''
                proxy_set_header X-Remote-User $remote_user; # provide username to CardDAV
                proxy_set_header X-Script-Name /carddav;
              '';
            };
            "/.well-known/carddav/" = {
              proxyPass = "http://radicale";
              extraConfig = ''
                proxy_set_header X-Remote-User $remote_user; # provide username to CardDAV
                proxy_set_header X-Script-Name /carddav;
              '';
            };
          };
        };
      };
    };
  };
}

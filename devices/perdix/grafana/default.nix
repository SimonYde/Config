{ inputs, config, ... }:
let
  inherit (config.syde) server;
in
{
  imports = [
    ./loki.nix
    ./mimir.nix
    ./tempo.nix
  ];

  age.secrets.grafanaClientSecret = {
    file = "${inputs.secrets}/grafanaClientSecret.age";
    owner = "grafana";
  };

  services = {
    grafana = {
      enable = true;

      settings = {
        server = {
          domain = "grafana.ts.${server.baseDomain}";
          http_addr = "127.0.0.1";
          http_port = 2342;
          root_url = "https://grafana.ts.${server.baseDomain}/";
        };

        database = {
          type = "postgres";
          user = "grafana";
          host = "/run/postgresql";
        };

        "auth.generic_oauth" = {
          enabled = true;

          name = "Kanidm";
          client_id = "grafana";
          client_secret = "$__file{/run/agenix/grafanaClientSecret}";

          auth_url = "https://auth.simonyde.com/ui/oauth2";
          token_url = "https://auth.simonyde.com/oauth2/token";
          api_url = "https://auth.simonyde.com/oauth2/openid/grafana/userinfo";

          login_attribute_path = "preferred_username";
          scopes = [
            "openid"
            "profile"
            "email"
            "groups"
          ];

          use_pkce = true;
          use_refresh_token = true;
          allow_sign_up = true;
          auto_login = true;
          allow_assign_grafana_admin = true;

          role_attribute_path = "contains(groups[*], 'grafana_admins@auth.simonyde.com') && 'GrafanaAdmin' || 'Viewer'";
        };

        dashboards.default_home_dashboard_path = "${./dashboards/home.json}";

        feature_toggles.enable = "autoMigrateOldPanels newVizTooltips";
        security.angular_support_enabled = false;
      };

      provision = {
        dashboards.settings = {
          apiVersion = 1;
          providers = [
            {
              name = "default";
              options.path = ./dashboards;
            }
          ];
        };

        datasources.settings = {
          apiVersion = 1;
          datasources = [
            {
              name = "Mimir";
              type = "prometheus";
              uid = "mimir";
              access = "proxy";
              url = "http://127.0.0.1:9000/prometheus";
              isDefault = true;
              jsonData = {
                prometheusType = "Mimir";
                timeInterval = "1m"; # Scrape interval configured in Prometheus
              };
            }
            {
              name = "Loki";
              type = "loki";
              uid = "loki";
              access = "proxy";
              url = "http://127.0.0.1:9090/";
            }
            {
              name = "Tempo";
              type = "tempo";
              uid = "tempo";
              access = "proxy";
              url = "http://127.0.0.1:9190/";
            }
            {
              name = "Mimir Alertmanager";
              type = "alertmanager";
              uid = "mimir-alertmanager";
              access = "proxy";
              url = "http://127.0.0.1:9000/";
              jsonData = {
                handleGrafanaManagedAlerts = true;
                implementation = "mimir";
              };
            }
          ];
        };
      };
    };

    postgresql = {
      enable = true;
      ensureDatabases = [ "grafana" ];

      ensureUsers = [
        {
          name = "grafana";
          ensureDBOwnership = true;
        }
      ];
    };

    nginx = {
      upstreams.grafana.servers."127.0.0.1:2342" = { };

      virtualHosts."grafana.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://grafana";
        proxyWebsockets = true;
      };
    };
  };
}

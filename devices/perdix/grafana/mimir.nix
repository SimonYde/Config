{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.syde) server email;
  alerts =
    pkgs.runCommand "mimir-alerts-checked"
      {
        src = ./alerts;
        nativeBuildInputs = with pkgs; [ prometheus.cli ];
      }
      ''
        promtool check rules $src/*
        mkdir $out
        cp -R $src $out/anonymous/
      '';
in
{
  users = {
    users.mimir = {
      isSystemUser = true;
      home = "/var/lib/mimir";
      createHome = true;
      group = "mimir";
      extraGroups = [ server.group ];
    };

    groups.mimir = { };
  };

  services = {
    mimir = {
      enable = true;

      configuration = {
        target = "all,alertmanager";
        multitenancy_enabled = false;

        common.storage.backend = "filesystem";

        server = {
          http_listen_port = 9000;
          grpc_listen_port = 9001;
          grpc_server_max_recv_msg_size = 104857600;
          grpc_server_max_send_msg_size = 104857600;
          grpc_server_max_concurrent_streams = 1000;
        };

        ingester.ring.replication_factor = 1;

        distributor.instance_limits.max_ingestion_rate = 0; # unlimited

        limits = {
          ingestion_rate = 1000000; # can't set to unlimited :(
          out_of_order_time_window = "12h";
          max_global_series_per_user = 0; # unlimited
          max_label_value_length = 10000; # we have pgscv queries that are LONG
        };

        ruler_storage = {
          backend = "local";
          local.directory = alerts;
        };

        alertmanager = {
          # FIXME: WHAT https://github.com/grafana/mimir/issues/2910
          sharding_ring.replication_factor = 2;
          fallback_config_file = pkgs.writers.writeYAML "alertmanager.yaml" {
            route = {
              group_by = [ "alertname" ];
              receiver = "email";
            };
            receivers = [
              {
                name = "email";
                email_configs = [
                  {
                    to = email.toAddress;
                    from = email.fromAddress;
                    smarthost = "${email.smtpServer}:${toString email.smtpPort}";
                    auth_username = email.smtpUsername;
                    auth_password_file = email.smtpPasswordPath;
                    require_tls = true;
                  }
                ];
              }
            ];
          };
        };
        alertmanager_storage.backend = "filesystem";

        ruler.alertmanager_url = "http://localhost:9000/alertmanager";
      };
    };

    nginx = {
      upstreams.mimir.servers."127.0.0.1:9000" = { };

      virtualHosts."mimir.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://mimir";
        proxyWebsockets = true;
      };
    };
  };

  systemd.services = {
    mimir = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "mimir";
      };
    };

    alloy.after = [
      "mimir.service"
      "nginx.service"
    ];
  };
}

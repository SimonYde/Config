{ config, pkgs, ... }:
let
  inherit (config.syde) server;
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
  # age.secrets.mimir-bot-token.file = ../../../secrets/mimir-bot-token.age;

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
              # receiver = "telegram";
            };
            receivers = [
              # {
              #   name = "telegram";
              #   telegram_configs = [
              #     {
              #       bot_token_file = "/run/credentials/mimir.service/bot-token";
              #       chat_id = 200667964;
              #       message = "{{ range $i, $a := .Alerts }}<b>{{ $a.Labels.alertname | html }}</b>: {{ $a.Status | html }} - {{ $a.Annotations.summary | html }}\n{{ end }}";
              #       parse_mode = "HTML";
              #     }
              #   ];
              # }
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

      # serviceConfig = {
      #   LoadCredential = [ "bot-token:/run/agenix/mimir-bot-token" ];
      # };
    };

    alloy.after = [
      "mimir.service"
      "nginx.service"
    ];
  };
}

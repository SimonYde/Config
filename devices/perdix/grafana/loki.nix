{ config, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    loki = {
      enable = true;

      configuration = {
        server = {
          http_listen_port = 9090;
          grpc_listen_port = 9095;

          # 16M
          grpc_server_max_recv_msg_size = 16777216;
          grpc_server_max_send_msg_size = 16777216;
        };

        auth_enabled = false;

        common = {
          path_prefix = "/var/lib/loki";
          storage.filesystem = {
            chunks_directory = "/var/lib/loki/chunks";
            rules_directory = "/var/lib/loki/rules";
          };
          replication_factor = 1;
          ring = {
            instance_addr = "127.0.0.1";
            kvstore.store = "inmemory";
          };
        };

        compactor = {
          working_directory = "/var/lib/loki/compactor";
          compaction_interval = "10m";
          retention_enabled = true;
          retention_delete_delay = "1s";
          retention_delete_worker_count = 150;
          delete_request_store = "filesystem";
        };

        limits_config.retention_period = "1w";

        schema_config = {
          configs = [
            {
              from = "2024-04-12";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
        };

        ruler.alertmanager_url = "http://127.0.0.1:9001";

        query_scheduler.max_outstanding_requests_per_tenant = 1024;
      };
    };

    nginx = {
      upstreams.loki.servers."127.0.0.1:9090" = { };

      virtualHosts."loki.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://loki";
        proxyWebsockets = true;
      };
    };
  };

  systemd.services.alloy.after = [
    "loki.service"
    "nginx.service"
  ];
}

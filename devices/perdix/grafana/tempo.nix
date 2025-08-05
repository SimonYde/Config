{
  services.tempo = {
    enable = true;
    settings = {
      server = {
        http_listen_address = "0.0.0.0";
        http_listen_port = 9190;
        grpc_listen_address = "0.0.0.0";
        grpc_listen_port = 9195;
      };
      distributor.receivers.otlp.protocols.http.endpoint = "0.0.0.0:4318";
      storage.trace = {
        backend = "local";
        wal.path = "/var/lib/tempo/wal";
        local.path = "/var/lib/tempo/blocks";
      };
      metrics_generator = {
        storage = {
          path = "/var/lib/tempo/generator/wal";
          remote_write = [
            {
              url = "http://localhost:9090/api/v1/write";
            }
          ];
        };
        traces_storage.path = "/var/lib/tempo/generator/traces";
        processor.local_blocks.flush_to_storage = true;
      };
      overrides.metrics_generator_processors = [
        "local-blocks"
        "service-graphs"
        "span-metrics"
      ];
    };
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 4318 ];
}

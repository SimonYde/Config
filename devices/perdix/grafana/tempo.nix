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
      memberlist.bind_port = 7947;
      distributor.receivers.otlp.protocols.http.endpoint = "0.0.0.0:4318";
      storage.trace = {
        backend = "local";
        wal.path = "/var/lib/tempo/wal";
        local.path = "/var/lib/tempo/blocks";
      };
      metrics_generator.storage = {
        path = "/var/lib/tempo/generator/wal";
        remote_write = [
          {
            url = "http://localhost:9000/api/v1/push";
          }
        ];
      };
      live_store = {
        shutdown_marker_dir = "/var/lib/tempo/live-store/shutdown-marker";
        wal.path = "/var/lib/tempo/live-store/traces";
      };
      block_builder.wal.path = "/var/lib/tempo/block-builder/wal";
      backend_scheduler.local_work_path = "/var/lib/tempo";
      overrides.defaults.metrics_generator.processors = [
        "service-graphs"
        "span-metrics"
        "host-info"
      ];
    };
  };

  systemd.services = {
    alloy.after = [
      "tempo.service"
      "nginx.service"
    ];

    tempo = {
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "mimir.service"
      ];
    };
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 4318 ];
}

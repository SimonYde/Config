{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.postgresql;
in
{
  config = lib.mkIf cfg.enable {
    services = {
      postgresql = {
        enableJIT = true;
        package = pkgs.postgresql_18;
        settings.shared_preload_libraries = "pg_stat_statements";
      };

      prometheus.exporters.postgres = {
        enable = true;
        port = 9003;
        runAsLocalSuperUser = true;
        extraFlags = [
          "--auto-discover-databases"
          "--collector.long_running_transactions"
          "--collector.stat_activity_autovacuum"
          "--collector.stat_statements"
        ];
      };

      pgscv = {
        enable = false;
        logLevel = "debug";
        settings = {
          services.postgres = {
            service_type = "postgres";
            conninfo = "postgres://";
          };
        };
      };

      alloy.scrape = {
        # pgscv.port = 9890;
        postgres.port = config.services.prometheus.exporters.postgres.port;
      };
    };
  };
}

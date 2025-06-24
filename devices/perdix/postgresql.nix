{
  pkgs,
  ...
}:

{
  services.postgresql = {
    enable = true;
    enableJIT = true;
    package = pkgs.postgresql_17;
    settings.shared_preload_libraries = "pg_stat_statements";
  };
}

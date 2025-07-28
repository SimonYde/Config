{ username, config, lib, pkgs, ... }:


{
  config = {
    services.postgresqlBackup = {
      enable = true;
      databases = config.services.postgresql.ensureDatabases;
    };
  };
}

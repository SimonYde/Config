{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  config = {
    age.secrets = {
      resticPassword = {
        file = "${inputs.secrets}/resticPassword.age";
        owner = "restic";
      };
    };

    services.postgresqlBackup = {
      enable = true;
      databases = config.services.postgresql.ensureDatabases;
    };

    services.restic = {
      backups.davvol = {
        timerConfig = {
          OnCalendar = "Sun *-*-* 05:00:00";
          Persistent = true;
        };
        repository = "sftp:tmcs@tmcs.davvol.dk:20001:/home/tmcs/restic";
        passwordFile = config.age.secrets.resticPassword.path;
        pruneOpts = [
          "--keep-last 3"
        ];
        paths = [
          "/var/backup"
          "/var/lib/nextcloud"
          "/var/lib/jellyfin"
          "/var/lib/vaultwarden"
          "/mnt/tank/nextcloud"
        ];
      };
    };
  };
}

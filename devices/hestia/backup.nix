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
        repository = "sftp:backup:/home/tmcs/restic";
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

    home-manager.users.root = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        matchBlocks = {
          "backup" = {
            port = 20001;
            hostname = "tmcs.davvol.dk";
            user = "tmcs";
            identityFile = "/etc/ssh/ssh_host_ed25519_key";
            serverAliveInterval = 60;
            serverAliveCountMax = 240;
          };
        };
      };
    };
  };
}

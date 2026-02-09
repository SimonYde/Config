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
          OnCalendar = "Thu,Sun *-*-* 04:00:00";
          Persistent = true;
        };
        repository = "sftp:backup:/home/tmcs/restic";
        passwordFile = config.age.secrets.resticPassword.path;
        pruneOpts = [
          "--keep-last 3"
        ];
        paths = [
          "/var/backup"
          "/var/lib/jellyfin"
          "/var/lib/vaultwarden"

          "/var/lib/nextcloud"
          "/mnt/tank/nextcloud"

          "/var/lib/immich"
          "/mnt/tank/immich"

          "/mnt/tank/opencloud"

          "/var/lib/paperless"
          "/mnt/tank/paperless"
        ];
        exclude = [
          "/mnt/tank/nextcloud/**/files_versions/Jellyfin/**"
          "/mnt/tank/nextcloud/**/files_versions/Jellyfin/**"
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

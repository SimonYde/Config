{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config.syde.server) internalDomain;
  inherit (config.networking) hostName;
in
{
  config = {
    age.secrets = {
      hestiaBackupPassword = {
        file = "${inputs.secrets}/restic/hestia-password.age";
      };
      # TODO(2026-10-25 Simon Yde): This should be generalized if used for other machines, e.g. perdix
      resticCredentialsFile = {
        file = "${inputs.secrets}/restic/eunomia-credentials.age";
      };
    };

    services.postgresqlBackup = {
      enable = true;
      databases = config.services.postgresql.ensureDatabases;
    };

    services.restic = {
      backups.hestia = {
        initialize = true;

        repository = "rest:https://backup.${internalDomain}/${hostName}";
        passwordFile = config.age.secrets.hestiaBackupPassword.path;
        environmentFile = config.age.secrets.resticCredentialsFile.path;

        # Dex keeps its signing keys and sessions in SQLite; copy it with the
        # online backup API instead of archiving the live file (and WAL).
        backupPrepareCommand = ''
          set -eu
          mkdir -p /var/backup/dex
          chmod 0700 /var/backup/dex
          ${pkgs.sqlite}/bin/sqlite3 /var/lib/dex/dex.db ".backup '/var/backup/dex/dex.db'"
          chmod 0600 /var/backup/dex/dex.db
        '';

        paths = [
          "/var/backup"
          "/var/lib/headscale"
          "/var/lib/netbird-mgmt"
          "/var/lib/kanidm"
        ];
        exclude = [
        ];

        timerConfig = {
          OnCalendar = "02:30";
          RandomizedDelaySec = "45m";
          Persistent = true;
        };

        pruneOpts = [
          "--keep-daily 14"
          "--keep-weekly 8"
          "--keep-monthly 12"
          "--keep-yearly 3"
          "--group-by"
          "host,tags"
        ];

        checkOpts = [ "--read-data-subset=2%" ];

        extraBackupArgs = [
          "--compression"
          "max"
          "--exclude-caches"
        ];
      };
    };
  };
}

{
  config,
  inputs,
  ...
}:
let
  inherit (config.syde.server) internalDomain;
in
{
  config = {
    age.secrets = {
      davvolPassword = {
        file = "${inputs.secrets}/restic/davvol-password.age";
      };
      "restic/htpasswd" = {
        file = "${inputs.secrets}/restic/htpasswd.age";
        owner = "restic";
        group = "restic";
        mode = "0400";
      };
    };

    services = {
      postgresqlBackup = {
        enable = true;
        databases = config.services.postgresql.ensureDatabases;
      };

      nginx = {
        upstreams.backup.servers."127.0.0.1:8000" = { };
        virtualHosts."backup.${internalDomain}" = {
          isInternal = true;

          locations = {
            "/" = {
              proxyPass = "http://backup";
              proxyWebsockets = true;

              extraConfig = ''
                client_max_body_size 128M;
                proxy_request_buffering off;
              '';
            };
          };
        };
      };

      restic = {
        server = {
          enable = true;
          listenAddress = "127.0.0.1:8000";
          dataDir = "/mnt/tank/backup";
          privateRepos = true; # one subdir per htpasswd user
          htpasswd-file = config.age.secrets."restic/htpasswd".path;
        };

        backups.davvol = {
          timerConfig = {
            OnCalendar = "Thu,Sun *-*-* 02:00:00";
            RandomizedDelaySec = "45m";
            Persistent = true;
          };
          repository = "sftp:davvol:/home/tmcs/restic";
          passwordFile = config.age.secrets.davvolPassword.path;
          pruneOpts = [
            "--keep-last 3"
          ];
          paths = [
            "/var/backup"
            "/var/lib/jellyfin"
            "/var/lib/vaultwarden"
            "/var/lib/mealie"

            "/var/lib/nextcloud"
            "/mnt/tank/nextcloud"

            "/var/lib/immich"
            "/mnt/tank/immich"

            "/var/lib/paperless"
            "/mnt/tank/paperless"

            "/mnt/tank/backup"
          ];
          exclude = [
            "/mnt/tank/nextcloud/**/files_versions/Jellyfin/**"
          ];
        };
      };
    };

    home-manager.users.root = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        settings = {
          "davvol" = {
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

{ config, ... }:
{
  age.secrets.vaultwarden = {
    file = ../../secrets/vaultwarden.age;
    owner = "vaultwarden";
  };

  services = {
    vaultwarden = {
      enable = true;

      dbBackend = "postgresql";

      environmentFile = "/run/agenix/vaultwarden";

      config = {
        rocketAddress = "127.0.0.1";
        rocketPort = 8881;

        databaseUrl = "postgresql://vaultwarden@/vaultwarden";

        domain = "https://bitwarden.simonyde.com";
        signupsAllowed = true;

        pushEnabled = true;
      };
    };

    postgresql = {
      ensureDatabases = [ "vaultwarden" ];
      ensureUsers = [
        {
          name = "vaultwarden";
          ensureDBOwnership = true;
        }
      ];
    };

    nginx = {
      upstreams.vaultwarden.servers."127.0.0.1:8881" = { };
      virtualHosts."password.${config.syde.server.baseDomain}".locations."/" = {
        proxyPass = "http://vaultwarden";
        proxyWebsockets = true;
      };
    };
  };

  # make sure we don't crash because postgres isn't ready
  systemd.services.vaultwarden.after = [ "postgresql.service" ];
}

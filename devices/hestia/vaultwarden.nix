{ config, inputs, ... }:
let
  inherit (config.syde) server email;
in
{
  age.secrets.vaultwarden = {
    file = "${inputs.secrets}/vaultwarden.age";
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

        smtpFrom = email.fromAddress;
        inherit (email) smtpUsername;
        smtpHost = email.smtpServer;

        databaseUrl = "postgresql://vaultwarden@/vaultwarden";

        domain = "https://password.${server.baseDomain}";
        signupsAllowed = true;

        extendedLogging = true;
        logLevel = "warn";

        pushEnabled = true;
      };
    };

    postgresql = {
      enable = true;
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
      virtualHosts."password.${server.baseDomain}".locations."/" = {
        proxyPass = "http://vaultwarden";
        proxyWebsockets = true;
      };
    };
  };

  syde.services.fail2ban.jails = {
    vaultwarden-login = {
      serviceName = "vaultwarden";
      failRegex = "^.*?Username or password is incorrect. Try again. IP: <ADDR>. Username:.*$";
    };

    vaultwarden-admin = {
      serviceName = "vaultwarden";
      failRegex = "^.*Invalid admin token. IP: <ADDR>.*$";
    };
  };

  # make sure we don't crash because postgres isn't ready
  systemd.services.vaultwarden.after = [ "postgresql.service" ];
}

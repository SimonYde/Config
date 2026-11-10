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
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8881;

        SMTP_FROM = email.fromAddress;
        SMTP_USERNAME = email.smtpUsername;
        SMTP_HOST = email.smtpServer;

        DATABASE_URL = "postgresql://vaultwarden@/vaultwarden";

        DOMAIN = "https://password.${server.baseDomain}";
        SIGNUPS_ALLOWED = false;

        PUSH_ENABLED = true;

        # NOTE(2026-11-08 Simon Yde): better passkey support
        EXPERIMENTAL_CLIENT_FEATURE_FLAGS = "fill-assist-targeting-rules,pm-30529-webauthn-related-origins";
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
      virtualHosts."password.${server.baseDomain}".locations = {
        "/" = {
          proxyPass = "http://vaultwarden";
          proxyWebsockets = true;
        };

        # The admin panel is only reachable from internal networks.
        "~* ^/admin" = {
          proxyPass = "http://vaultwarden";
          proxyWebsockets = true;
          internalOnly = true;
        };
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

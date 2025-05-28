{ ... }:
{
  age.secrets.vaultwarden = {
    file = ../../secrets/vaultwarden.age;
    owner = "vaultwarden";
  };

  services = {
    vaultwarden = {
      enable = true;

      environmentFile = "/run/agenix/vaultwarden";

      config = {
        rocketAddress = "127.0.0.1";
        rocketPort = 8881;

        domain = "https://bitwarden.simonyde.com";
        signupsAllowed = false;

        pushEnabled = true;
      };
    };

    nginx = {
      upstreams.vaultwarden.servers."127.0.0.1:8881" = { };
      virtualHosts."bitwarden.simonyde.com".locations."/" = {
        proxyPass = "http://vaultwarden";
        proxyWebsockets = true;
      };
    };
  };
}

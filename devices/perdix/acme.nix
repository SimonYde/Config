{ inputs, lib, ... }:
{
  users.groups.acme = { };

  age.secrets.dns.file = "${inputs.secrets}/dns.age";

  security.acme = {
    defaults = {
      email = "acme@simonyde.com";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      environmentFile = "/run/agenix/dns";
    };

    acceptTerms = true;
  };

  services.nginx.virtualHosts.default = {
    default = true;
    rejectSSL = true;
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
    locations."/".return = "404";
  };
}

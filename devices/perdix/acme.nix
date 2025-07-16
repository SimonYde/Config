{ inputs, ... }:
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
}

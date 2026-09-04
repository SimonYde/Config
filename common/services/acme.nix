{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkForce
    mkIf
    ;

  cfg = config.syde.acme;
in
{
  options.syde.acme = {
    enable = mkEnableOption "ACME using Cloudflare DNS for challenge";
  };

  config = mkIf cfg.enable {
    users.groups.acme = { };

    age.secrets.dns.file = "${inputs.secrets}/dns.age";

    security.acme = {
      defaults = {
        email = mkDefault "acme@simonyde.com";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        environmentFile = config.age.secrets.dns.path;
      };

      acceptTerms = true;
    };

    services.nginx.virtualHosts.default = {
      default = true;
      rejectSSL = true;
      enableACME = mkForce false;
      forceSSL = mkForce false;
      locations."/".return = "404";
    };
  };
}

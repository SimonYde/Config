{
  inputs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkForce mkOption types;
in
{
  options.services.nginx = {
    virtualHosts = mkOption {
      type = types.attrsOf (
        types.submodule {
          # Priority slightly above normal explicit values, so it wins against service modules,
          # but still loses to mkForce
          config = lib.mkOverride 80 {
            acmeRoot = "/var/lib/acme/.well-known/acme-challenge";
          };
        }
      );
    };
  };

  config = {
    services.nginx.virtualHosts = {
      "www.tmcs.dk" = {
        default = true;

        locations."/" = {
          extraConfig = ''
            return 418;
          '';
        };
      };

      "tranumparken.ts.simonyde.com" = {
        acmeRoot = mkForce null;
        enableACME = mkForce false;
        useACMEHost = "ts.simonyde.com";

        locations."/" = {
          proxyPass = "https://192.168.2.1:8443";
          proxyWebsockets = true;
        };
      };
    };

    users.groups.acme = { };

    age.secrets.dns.file = "${inputs.secrets}/dns.age";

    security.acme = {
      acceptTerms = true;

      defaults.email = "s@tmcs.dk";

      certs."ts.simonyde.com" = {
        email = "acme@simonyde.com";
        domain = "*.ts.simonyde.com";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        environmentFile = "/run/agenix/dns";
      };
    };
  };
}

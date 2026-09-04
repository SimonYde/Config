{ inputs, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkForce
    mkMerge
    mkIf
    mkOption
    mkOverride
    types
    ;
in
{
  options.services.nginx = {
    virtualHosts = mkOption {
      type = types.attrsOf (
        types.submodule (
          { config, ... }: {
            options.isInternal = mkEnableOption ''
              Whether this virtualHosts is meant to run over tailnet only (hence requiring DNS ACME challenge)
            '';

            config = mkMerge [
              {
                # Priority slightly above normal explicit values, so it wins
                # against service modules, but still loses to mkForce
                acmeRoot = mkOverride 80 "/var/lib/acme/.well-known/acme-challenge";
              }
              (mkIf config.isInternal {
                acmeRoot = mkForce null;
                enableACME = mkForce false;
                useACMEHost = "i.simonyde.com";
              })
            ];
          }
        )
      );
    };
  };

  config = {
    syde.acme.enable = true;

    services.nginx.virtualHosts."tranumparken.i.simonyde.com" = {
      isInternal = true;

      locations."/" = {
        proxyPass = "https://192.168.2.1:8443";
        proxyWebsockets = true;
      };
    };

    security.acme = {
      defaults.email = "s@tmcs.dk";

      certs."i.simonyde.com" = {
        email = "acme@simonyde.com";
        domain = "*.i.simonyde.com";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        environmentFile = "/run/agenix/dns";
      };
    };
  };
}

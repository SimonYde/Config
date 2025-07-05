{ config, lib, ... }:

let
  inherit (lib) mkOption types;
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
    services.nginx.virtualHosts."www.tmcs.dk" = {
      default = true;
      locations."/" = {
        extraConfig = ''
          return 418;
        '';
      };
    };

    users.groups.acme = { };

    security.acme = {
      acceptTerms = true;
      defaults.email = "s@tmcs.dk";
    };
  };
}

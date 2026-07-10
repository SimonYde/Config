{ config, lib, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    seerr = {
      enable = true;
      port = 5055;
    };

    nginx = {
      upstreams.seerr.servers."127.0.0.1:5055" = { };

      virtualHosts."seerr.ts.simonyde.com" = {
        acmeRoot = lib.mkForce null;
        enableACME = lib.mkForce false;
        useACMEHost = "ts.simonyde.com";

        locations."/" = {
          proxyPass = "http://seerr";
          proxyWebsockets = true;
        };
      };
    };
  };
}

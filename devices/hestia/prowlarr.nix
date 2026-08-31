{ config, lib, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    prowlarr.enable = true;

    nginx = {
      upstreams.prowlarr.servers."127.0.0.1:9696" = { };

      virtualHosts."prowlarr.i.simonyde.com" = {
        acmeRoot = lib.mkForce null;
        enableACME = lib.mkForce false;
        useACMEHost = "i.simonyde.com";

        locations."/" = {
          proxyPass = "http://prowlarr";
          proxyWebsockets = true;
        };
      };
    };
  };
}

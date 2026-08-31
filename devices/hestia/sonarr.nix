{ config, lib, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    sonarr = {
      enable = true;
      inherit (server) user group;
    };

    nginx = {
      upstreams.sonarr.servers."127.0.0.1:8989" = { };

      virtualHosts."sonarr.i.simonyde.com" = {
        acmeRoot = lib.mkForce null;
        enableACME = lib.mkForce false;
        useACMEHost = "i.simonyde.com";

        locations."/" = {
          proxyPass = "http://sonarr";
          proxyWebsockets = true;
        };
      };
    };
  };
}

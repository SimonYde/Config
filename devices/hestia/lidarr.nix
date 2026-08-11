{ config, lib, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    lidarr = {
      enable = true;
      inherit (server) user group;
    };

    nginx = {
      upstreams.lidarr.servers."127.0.0.1:8686" = { };

      virtualHosts."lidarr.ts.simonyde.com" = {
        acmeRoot = lib.mkForce null;
        enableACME = lib.mkForce false;
        useACMEHost = "ts.simonyde.com";

        locations."/" = {
          proxyPass = "http://lidarr";
          proxyWebsockets = true;
        };
      };

    };
  };
}

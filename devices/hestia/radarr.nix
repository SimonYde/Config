{ config, lib, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    radarr = {
      enable = true;
      inherit (server) user group;
    };

    nginx = {
      upstreams.radarr.servers."127.0.0.1:7878" = { };

      virtualHosts."radarr.i.simonyde.com" = {
        isInternal = true;

        locations."/" = {
          proxyPass = "http://radarr";
          proxyWebsockets = true;
        };
      };
    };
  };
}

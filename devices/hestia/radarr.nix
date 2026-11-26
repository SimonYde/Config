{ config, lib, ... }:
let
  inherit (config.syde) server;
  inherit (server) internalDomain;
in
{
  services = {
    radarr = {
      enable = true;
      inherit (server) user group;
    };

    nginx = {
      upstreams.radarr.servers."127.0.0.1:7878" = { };

      virtualHosts."radarr.${internalDomain}" = {
        isInternal = true;

        locations."/" = {
          proxyPass = "http://radarr";
          proxyWebsockets = true;
        };
      };
    };
  };
}

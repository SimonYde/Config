{ config, lib, ... }:
let
  inherit (config.syde) server;
  inherit (server) internalDomain;
in
{
  services = {
    lidarr = {
      enable = true;
      inherit (server) user group;
    };

    nginx = {
      upstreams.lidarr.servers."127.0.0.1:8686" = { };

      virtualHosts."lidarr.${internalDomain}" = {
        isInternal = true;

        locations."/" = {
          proxyPass = "http://lidarr";
          proxyWebsockets = true;
        };
      };

    };
  };
}

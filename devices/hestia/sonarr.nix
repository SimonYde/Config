{ config, lib, ... }:
let
  inherit (config.syde) server;
  inherit (server) internalDomain;
in
{
  services = {
    sonarr = {
      enable = true;
      inherit (server) user group;
    };

    nginx = {
      upstreams.sonarr.servers."127.0.0.1:8989" = { };

      virtualHosts."sonarr.${internalDomain}" = {
        isInternal = true;

        locations."/" = {
          proxyPass = "http://sonarr";
          proxyWebsockets = true;
        };
      };
    };
  };
}

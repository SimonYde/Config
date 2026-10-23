{ config, lib, ... }:
let
  inherit (config.syde) server;
  inherit (server) internalDomain;
in
{
  services = {
    prowlarr.enable = true;

    nginx = {
      upstreams.prowlarr.servers."127.0.0.1:9696" = { };

      virtualHosts."prowlarr.${internalDomain}" = {
        isInternal = true;

        locations."/" = {
          proxyPass = "http://prowlarr";
          proxyWebsockets = true;
        };
      };
    };
  };
}

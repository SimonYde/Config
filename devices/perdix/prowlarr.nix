{ config, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    prowlarr.enable = true;

    nginx = {
      upstreams.prowlarr.servers."127.0.0.1:9696" = { };

      virtualHosts."prowlarr.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://prowlarr";
        proxyWebsockets = true;
      };
    };
  };
}

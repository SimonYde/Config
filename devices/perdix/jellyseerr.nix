{ config, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    jellyseerr = {
      enable = true;
      port = 5055;
    };

    nginx = {
      upstreams.jellyseerr.servers."127.0.0.1:5055" = { };

      virtualHosts."jellyseerr.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://jellyseerr";
        proxyWebsockets = true;
      };
    };
  };
}

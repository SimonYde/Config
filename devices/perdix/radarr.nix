{ config, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    radarr = {
      enable = true;
      inherit (server) user;
    };

    nginx = {
      upstreams.radarr.servers."127.0.0.1:7878" = { };

      virtualHosts."radarr.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://radarr";
        proxyWebsockets = true;
      };
    };
  };
}

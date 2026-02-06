{ config, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    lidarr = {
      enable = true;
      inherit (server) user;
    };

    nginx = {
      upstreams.lidarr.servers."127.0.0.1:8686" = { };

      virtualHosts."lidarr.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://lidarr";
        proxyWebsockets = true;
      };
    };
  };
}

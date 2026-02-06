{ config, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    sonarr = {
      enable = true;
      inherit (server) user;
    };

    nginx = {
      upstreams.sonarr.servers."127.0.0.1:8989" = { };

      virtualHosts."sonarr.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://sonarr";
        proxyWebsockets = true;
      };
    };
  };
}

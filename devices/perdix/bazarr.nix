{ config, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    bazarr = {
      enable = true;
      inherit (server) user;
    };

    nginx = {
      upstreams.bazarr.servers."127.0.0.1:6767" = { };

      virtualHosts."bazarr.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://bazarr";
        proxyWebsockets = true;
      };
    };
  };
}

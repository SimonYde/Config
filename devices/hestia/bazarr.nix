{ config, lib, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    bazarr = {
      enable = true;
      inherit (server) user group;
    };

    nginx = {
      upstreams.bazarr.servers."127.0.0.1:6767" = { };

      virtualHosts."bazarr.ts.simonyde.com" = {
        acmeRoot = lib.mkForce null;
        enableACME = lib.mkForce false;
        useACMEHost = "ts.simonyde.com";

        locations."/" = {
          proxyPass = "http://bazarr";
          proxyWebsockets = true;
        };
      };
    };
  };
}

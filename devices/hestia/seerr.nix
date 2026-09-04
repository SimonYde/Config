{ config, lib, ... }:
let
  inherit (config.syde) server;
in
{
  services = {
    seerr = {
      enable = true;
      port = 5055;
    };

    nginx = {
      upstreams.seerr.servers."127.0.0.1:5055" = { };

      virtualHosts."seerr.i.simonyde.com" = {
        isInternal = true;

        locations."/" = {
          proxyPass = "http://seerr";
          proxyWebsockets = true;
        };
      };
    };
  };
}

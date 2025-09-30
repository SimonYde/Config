{ config, lib, ... }:
let
  inherit (config.syde) server;
  cfg = config.services.languagetool;
in
{
  config = lib.mkIf cfg.enable {
    services.languagetool = {
      port = 8088;
      allowOrigin = "*"; # Running behind tailscale anyway
    };

    services.nginx = {
      upstreams.languagetool.servers."127.0.0.1:${toString cfg.port}" = { };
      virtualHosts."languagetool.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://languagetool";
        proxyWebsockets = true;
      };
    };
  };
}

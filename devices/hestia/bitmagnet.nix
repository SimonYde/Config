{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkForce mkIf;

  cfg = config.services.bitmagnet;
in
{
  config = mkIf cfg.enable {
    systemd.services.bitmagnet.useNetworkNamespace = true;

    services = {
      bitmagnet = {
        openFirewall = true;

        settings = {
          # don't load the network too hard (default: 10)
          dht_crawler.scaling_factor = 3;
          # don't index stuff we don't care about
          classifier.flags.delete_content_types = [
            "game"
            "software"
            "xxx"
          ];
        };
      };

      nginx = {
        upstreams.bitmagnet.servers."127.0.0.1:3333" = { };
        virtualHosts."bitmagnet.i.simonyde.com" = {
          acmeRoot = mkForce null;
          enableACME = mkForce false;
          useACMEHost = "i.simonyde.com";

          locations."/" = {
            proxyPass = "http://bitmagnet";
            proxyWebsockets = true;
          };
        };

      };

      wireguard-netns = {
        proxies.bitmagnet = {
          port = 3333;
          inherit (config.services.bitmagnet) user group;
        };
      };

      alloy.scrape.bitmagnet.port = 3333;
    };
  };
}

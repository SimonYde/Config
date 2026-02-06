{ config, lib, pkgs, ... }:
let
  inherit (config.syde) server;
  inherit (config.services.wireguard-netns) namespace;
in
{
  services = {
    bitmagnet = {
      enable = true;
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

      virtualHosts."bitmagnet.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://bitmagnet";
        proxyWebsockets = true;
      };
    };

    alloy.scrape.bitmagnet.port = 3333;
  };

  systemd = lib.mkIf config.services.wireguard-netns.enable {
    services.bitmagnet = {
      bindsTo = [ "netns@${namespace}.service" ];
      requires = [
        "network-online.target"
        "${namespace}.service"
      ];
      serviceConfig = {
        NetworkNamespacePath = [ "/run/netns/${namespace}" ];
        InaccessiblePaths = [
          "/run/nscd"
        ];

        BindReadOnlyPaths = [
          "/etc/netns/${namespace}/resolv.conf:/etc/resolv.conf:norbind"
        ];
      };
    };

    sockets."bitmagnet-proxy" = {
      enable = true;
      description = "Socket for Proxy to bitmagnet";
      listenStreams = [ "3333" ];
      wantedBy = [ "sockets.target" ];
    };

    services."bitmagnet-proxy" = {
      enable = true;
      description = "Proxy to bitmagnet in Network Namespace";
      requires = [
        "bitmagnet.service"
        "bitmagnet-proxy.socket"
      ];
      after = [
        "bitmagnet.service"
        "bitmagnet-proxy.socket"
      ];
      unitConfig = {
        JoinsNamespaceOf = "bitmagnet.service";
      };
      serviceConfig = {
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:3333";
        PrivateNetwork = "yes";
        User = config.services.bitmagnet.user;
        Group = config.services.bitmagnet.group;
      };
    };
  };

}

{ config, ... }:
{
  services = {
    resolved.enable = true;

    netbird = {
      # useRoutingFeatures = "server";

      clients.default = {
        name = "netbird";
        interface = "nb0";
        port = 51823;
      };
    };
  };

  # needed for netbird to access resolved
  security.polkit.enable = true;

  systemd = {
    network.wait-online.ignoredInterfaces = [ "nb0" ];

    # debug hanging connections maybe
    services.netbird.environment.NB_WG_DEBUG = "true";
  };

  networking.firewall.allowedUDPPorts = [ config.services.netbird.clients.default.port ];
}

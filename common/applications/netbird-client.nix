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

        # systemd-resolved already owns port 53; keep NetBird's resolver on its fallback port and tell resolved where to send NetBird queries.
        dns-resolver = {
          address = "127.0.0.1";
          port = 5053;
        };
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
  networking.firewall.trustedInterfaces = [ "nb0" ];
}

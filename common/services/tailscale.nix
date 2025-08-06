{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.services.tailscale;
in
{
  config = lib.mkIf cfg.enable {
    services.tailscale = {
      useRoutingFeatures = "both";

      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

    systemd = {
      network.wait-online.ignoredInterfaces = [ cfg.interfaceName ];
      # # FIXME: figure out why autodetect is broken
      services.tailscaled.environment.TS_DEBUG_FIREWALL_MODE = "nftables";
    };

    networking.firewall = {
      trustedInterfaces = [ cfg.interfaceName ];
      allowedUDPPorts = [ cfg.port ];
    };

    environment.etc."alloy/tailscale.alloy".text = ''
      scrape_url "tailscale" {
        name = "tailscale"
        url  = "100.100.100.100"
      }
    '';
  };
}

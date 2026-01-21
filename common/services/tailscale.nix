{ config, lib, inputs, ... }:
let
  cfg = config.services.tailscale;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets.tailscaleAuthKey.file = "${inputs.secrets}/tailscaleAuthKey.age";

    services.tailscale = {
      authKeyFile = config.age.secrets.tailscaleAuthKey.path;
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
      scrape "tailscale" {
        name = "tailscale"
        targets = [
          {"__address__" = "100.100.100.100", "instance" = constants.hostname},
        ]
      }
    '';
  };
}

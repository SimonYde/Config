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
      openFirewall = true;
      useRoutingFeatures = "both";

      extraUpFlags = [
        "--ssh"
        "--operator=${username}"
      ];

      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

    networking.firewall.trustedInterfaces = [ cfg.interfaceName ];
  };
}

{ config, ... }:
{
  config = {
    services.tailscale = {
      extraUpFlags = [
        "--ssh"
        "--operator=${config.syde.user}"
      ];
      useRoutingFeatures = "both";
      openFirewall = true;
      extraDaemonFlags = [
        "--no-logs-no-support"
      ];
    };
  };
}

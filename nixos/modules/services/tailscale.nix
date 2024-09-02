{ ... }:
{
  config = {
    services.tailscale = {
      extraUpFlags = [ "--ssh" ];
      useRoutingFeatures = "both";
      openFirewall = true;
      extraDaemonFlags = [
        "--no-logs-no-support"
      ];
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types mkDefault mkOption;

  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;

  latestZfsKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );

  cfg = config.syde.server;
in
{
  options.syde.server = {
    baseDomain = mkOption {
      type = types.str;
      default = "";
      description = ''
        Base domain name to be used to access the homelab services via Caddy reverse proxy
      '';
    };

    user = lib.mkOption {
      default = "share";
      type = lib.types.str;
      description = ''
        User to run the homelab/server services as
      '';
    };

    group = lib.mkOption {
      default = "share";
      type = lib.types.str;
      description = ''
        Group to run the homelab/server services as
      '';
    };
  };

  imports = [ ./. ];

  config = {
    boot = {
      kernelPackages = mkDefault latestZfsKernelPackage;
      supportedFilesystems.zfs = mkDefault true;

      # optimized network settings
      kernel.sysctl = {
        # buffer limits: 32M max, 16M default
        "net.core.rmem_max" = 33554432;
        "net.core.wmem_max" = 33554432;
        "net.core.rmem_default" = 16777216;
        "net.core.wmem_default" = 16777216;
        "net.core.optmem_max" = 40960;

        # cloudflare uses this for balancing latency and throughput
        # https://blog.cloudflare.com/the-story-of-one-latency-spike/
        "net.ipv4.tcp_mem" = "786432 1048576 26777216";
        "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
        "net.ipv4.tcp_wmem" = "4096 65536 16777216";

        # http://www.nateware.com/linux-network-tuning-for-2013.html
        "net.core.netdev_max_backlog" = 100000;
        "net.core.netdev_budget" = 100000;
        "net.core.netdev_budget_usecs" = 100000;

        "net.ipv4.tcp_max_syn_backlog" = 30000;
        "net.ipv4.tcp_max_tw_buckets" = 2000000;
        "net.ipv4.tcp_tw_reuse" = 1;
        "net.ipv4.tcp_fin_timeout" = 10;

        "net.ipv4.udp_rmem_min" = 8192;
        "net.ipv4.udp_wmem_min" = 8192;
      };
    };

    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    # Save some space on servers
    environment.defaultPackages = [ ];
    documentation.enable = false;

    networking = {
      firewall.enable = true;
      firewall.logRefusedConnections = false;
      useDHCP = mkDefault true;
    };

    systemd.services.alloy.environment.ALLOY_NODE_KIND = "server";
  };
}

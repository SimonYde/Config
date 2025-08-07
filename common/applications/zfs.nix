{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkDefault
    mkIf
    filterAttrs
    sort
    last
    versionOlder
    ;

  zfsCompatibleKernelPackages = filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;

  latestZfsKernelPackage = last (
    sort (a: b: (versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );

  cfg = config.syde.zfs;
in

{
  options.syde.zfs = {
    enable = mkEnableOption "enable ZFS filesystem";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelPackages = mkDefault latestZfsKernelPackage;
      supportedFilesystems.zfs = true;
    };

    services = {
      zfs.autoScrub.enable = true;
      prometheus.exporters.zfs = {
        inherit (config.syde.monitoring) enable;
        port = 9134;
      };

      alloy.scrape.zfs = {
        port = config.services.prometheus.exporters.zfs.port;
      };
    };
  };
}

{
  lib,
  modulesPath,
  pkgs,
  config,
  username,
  ...
}:

let
  inherit (lib)
    filterAttrs
    last
    mkForce
    sort
    versionOlder
    ;

  zfsCompatibleKernelPackages = filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;

  latestKernelPackage = last (
    sort (a: b: (versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    ../common
  ];

  system.stateVersion = lib.trivial.release;

  boot = {
    kernelPackages = latestKernelPackage;
    supportedFilesystems.zfs = lib.mkForce true;
    supportedFilesystems.bcachefs = true;
  };

  users.users.nixos.enable = mkForce false;

  services.displayManager.autoLogin.user = username;

  system.tools = {
    nixos-build-vms.enable = mkForce true;
    nixos-enter.enable = mkForce true;
    nixos-generate-config.enable = mkForce true;
    nixos-install.enable = mkForce true;
    nixos-option.enable = mkForce true;
  };
}

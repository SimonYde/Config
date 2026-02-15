{
  lib,
  modulesPath,
  pkgs,
  config,
  ...
}:

let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
  keys = import ../keys.nix;
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"

    ../common/base/nix-settings.nix
  ];

  boot = {
    kernelPackages = latestKernelPackage;
    supportedFilesystems.zfs = lib.mkForce true;
    supportedFilesystems.bcachefs = true;
  };

  services.openssh = {
    enable = true;

    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      AllowAgentForwarding = true;
    };
  };

  users.users.root = {
    shell = pkgs.nushell-wrapped;
    openssh.authorizedKeys.keys = [ keys.syde ];
  };
  users.users.nixos = {
    shell = pkgs.nushell-wrapped;
    openssh.authorizedKeys.keys = [ keys.syde ];
  };
}

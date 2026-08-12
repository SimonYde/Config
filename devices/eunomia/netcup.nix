{ pkgs, modulesPath, ... }:
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-partlabel/root";
      fsType = "bcachefs";
      options = [
        "version_upgrade=compatible"
        "discard"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/boot";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  networking.useDHCP = false;

  systemd.network = {
    enable = true;

    networks.netcup = {
      name = "ens3";
      DHCP = "ipv4";
      linkConfig.RequiredFamilyForOnline = "both";
    };
  };

  services.qemuGuest.enable = true;
}

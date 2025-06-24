{
  pkgs,
  inputs,
  config,
  lib,
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
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../../common/server.nix

    ./acme.nix
    ./homepage.nix
    ./jellyfin.nix
    ./media.nix
    ./nginx.nix
    ./postgresql.nix
    ./vaultwarden.nix
  ];

  # Personal configurations
  syde = {
    hardware = {
      nvidia.enable = false;
      amd = {
        cpu.enable = true;
      };
    };
  };

  boot = {
    kernelPackages = latestKernelPackage;

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
    ];

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };

  console = {
    earlySetup = true;
    useXkbConfig = true;
    font = "ter-i24n";
    packages = [ pkgs.terminus_font ];
  };

  environment.systemPackages = [
    pkgs.wezterm
  ];

  hardware = {
    enableAllHardware = true;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  networking = {
    useDHCP = lib.mkDefault true;

    firewall.enable = true;

    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    wireguard.enable = true;
  };

  services = {
    xserver.xkb.layout = "us(colemak_dh)";
    logind.lidSwitch = "ignore";

    syncthing.enable = true;

    zfs.autoScrub.enable = true;
  };

  # $ head -c 4 /dev/urandom | xxd -p
  networking.hostId = "d10ef1c6";

  fileSystems."/" = {
    neededForBoot = true;
    device = "zpool/root";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/nix" = {
    device = "zpool/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var" = {
    device = "zpool/var";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/home" = {
    device = "zpool/home";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/49B2-C8B0";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
}

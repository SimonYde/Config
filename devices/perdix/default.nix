{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../../common/server.nix
    ./acme.nix
  ];

  # Personal configurations
  syde = {
    server.baseDomain = "simonyde.com";

    hardware = {
      nvidia.enable = false;
      amd = {
        cpu.enable = true;
      };
    };
  };

  boot = {
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

  hardware = {
    enableAllHardware = true;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    wireguard.enable = true;
  };
  services = {
    logind.lidSwitch = "ignore";

    nginx = {
      enable = true;

      virtualHosts."edgeos.ts.simonyde.com".locations."/" = {
        proxyPass = "https://192.168.1.1:8443";
        proxyWebsockets = true;
      };
    };

    syncthing.enable = true;
    xserver.xkb.layout = "us(colemak_dh)";
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

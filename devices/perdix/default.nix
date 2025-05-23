{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../../common/server.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

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

  # Personal configurations
  syde = {
    hardware = {
      nvidia.enable = true;
      amd = {
        cpu.enable = true;
      };
    };
  };

  hardware = {
    enableAllHardware = true;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  programs = {
    partition-manager.enable = true;
  };

  networking = {
    useDHCP = lib.mkDefault true;

    firewall = {
      enable = true;

      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
      ];

      trustedInterfaces = [ "tailscale0" ];
    };

    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    logind.lidSwitch = "ignore";

    tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
    };

    syncthing.enable = true;
  };

  networking.wireguard.enable = true;

  # Filesystems
  boot.initrd.luks.devices."luks-8c2b7981-b3e3-470e-aae7-2834b1352fa5".device =
    "/dev/disk/by-uuid/8c2b7981-b3e3-470e-aae7-2834b1352fa5";
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/SYSTEM_DRV";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
}

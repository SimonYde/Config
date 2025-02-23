{
  pkgs,
  ...
}:
{
  imports = [ ../standard.nix ];

  config = {
    networking.hostName = "icarus";

    boot.kernelPackages = pkgs.linuxPackages_zen;

    # Personal configurations
    syde = {
      ssh.enable = true;
      pc.enable = true;
      pc.keyboard.layout = "eu";
      gaming.enable = true;
      hardware = {
        nvidia = {
          enable = true;
          dedicated = true;
        };
        amd = {
          cpu.enable = true;
          gpu.enable = false;
        };
      };
    };

    programs = {
      nh.enable = true;
      hyprland.enable = true;
    };

    services.desktopManager.cosmic.enable = false;
    services.displayManager.cosmic-greeter.enable = false;

    services = {
      ratbagd.enable = true;
      blueman.enable = true;
      ollama.enable = true;
      tailscale.enable = true;
      syncthing.enable = true;
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    powerManagement.cpuFreqGovernor = "performance";

    networking.wireguard.enable = true;

    boot.loader.systemd-boot.windows = {
      "11-home" = {
        title = "Windows 11 Home";
        efiDeviceHandle = "HD0b";
      };
    };

    # Filesystems
    boot.initrd.luks.devices."luks-1d0e845e-dd09-4c75-b92c-9ea67a00757b".device =
      "/dev/disk/by-uuid/1d0e845e-dd09-4c75-b92c-9ea67a00757b";
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/157E-B4A5";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/e37c4644-2a85-4cfd-adaf-87961ad57a72";
      fsType = "ext4";
    };

    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 48 * 1024;
      }
    ];

  };
}

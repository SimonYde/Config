{
  pkgs,
  username,
  lib,
  ...
}:
{
  imports = [
    ../common/desktop.nix
    ../common/nixos/hyprland.nix
    ../common/nixos/gaming.nix
  ];

  # Personal configurations
  syde = {
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

  services.xserver.xkb.layout = "eu";

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    loader.systemd-boot.windows."11-home" = {
      title = "Windows 11 Home";
      efiDeviceHandle = "HD0b";
    };
  };

  console = {
    font = lib.mkForce "ter-i32b";
    earlySetup = true;
  };

  services = {
    ratbagd.enable = true;
    tailscale.enable = true;
    syncthing.enable = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  networking.wireguard.enable = true;

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

  # swapDevices = [
  #   {
  #     device = "/var/lib/swapfile";
  #     size = 48 * 1024;
  #   }
  # ];

  home-manager.users.${username} = {

    services = {
      blanket.enable = true;
    };

    programs.hyprlock.settings.general.screencopy_mode = 1; # NOTE: nvidia problems

    wayland.windowManager.hyprland.extraConfig = # hyprlang
      ''
        workspace=1, monitor:DP-1, default:true
        workspace=2, monitor:DP-1
        workspace=3, monitor:DP-1
        workspace=4, monitor:DP-1
        workspace=5, monitor:DP-1
        workspace=6, monitor:DP-1

        workspace=7, monitor:HDMI-A-1, default:true
        workspace=8, monitor:HDMI-A-1

        workspace=9, monitor:DP-3, default:true
        workspace=10, monitor:DP-3
      '';
  };
}

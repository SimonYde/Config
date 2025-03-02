{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.syde) user;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../common/desktop.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  console.earlySetup = true;

  # Personal configurations
  syde = {
    laptop.enable = true;

    gaming = {
      enable = true;
      specialisation = true;
    };

    hardware = {
      nvidia.enable = true;
      amd = {
        cpu.enable = true;
        gpu.enable = true;
      };
    };
  };

  programs = {
    nix-ld.enable = true;
    wireshark.enable = true;
    nh.enable = true;
    hyprland.enable = true;
  };

  services = {
    desktopManager.cosmic.enable = false;
    displayManager.cosmic-greeter.enable = false;

    tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
    };

    syncthing.enable = true;

    kanata.enable = true;
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

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  home-manager.users.${user} = {

    home.keyboard = {
      layout = "us(colemak_dh),dk";
      options = [
        "caps:escape"
        "grp:rctrl_toggle"
      ];
    };

    wayland.windowManager.hyprland.enable = true;

    services.hypridle =
      let
        brightnessctl = lib.getExe pkgs.brightnessctl;
      in
      {
        settings = {
          listener = [
            {
              timeout = 60;
              # NOTE: name of device is specific for this device
              on-timeout = "${brightnessctl} -sd platform::kbd_backlight set 0";
              on-resume = "${brightnessctl} -rd platform::kbd_backlight";
            }
            {
              timeout = 180;
              on-timeout = "${brightnessctl} -s s 50%-";
              on-resume = "${brightnessctl} -r";
            }
            {
              timeout = 360;
              on-timeout = "loginctl lock-session";
              on-resume = "";
            }
            {
              timeout = 900;
              on-timeout = "systemctl suspend";
              on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
            }
          ];
        };
      };

  };
}

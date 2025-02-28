{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../common/nixos
  ];

  networking.hostName = "perdix";

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Personal configurations
  syde = {
    ssh.enable = true;
    laptop.enable = true;
    pc.enable = true;
    gaming.enable = true;
    gaming.specialisation = true;
    hardware = {
      nvidia.enable = true;
      amd.cpu.enable = true;
      amd.gpu.enable = true;
    };
  };

  programs = {
    nix-ld.enable = true;
    wireshark.enable = true;
    nh.enable = true;
    hyprland.enable = true;
  };

  services.desktopManager.cosmic.enable = false;
  services.displayManager.cosmic-greeter.enable = false;

  services = {
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

  home-manager.users.syde =
    { pkgs, ... }:
    {

      # Personal modules
      syde = {
        gui.enable = true;
        programming.enable = true;
        ssh.enable = true;
        terminal.enable = true;
        desktop.cosmic.enable = false;
        theming.enable = true;
      };

      home.packages = with pkgs; [
        brightnessctl
      ];

      home.keyboard = {
        layout = "us(colemak_dh),dk";
        options = [
          "caps:escape"
          "grp:rctrl_toggle"
        ];
      };

      services.hypridle = {
        settings = {
          listener = [
            {
              timeout = 60;
              # NOTE: name of device is specific for this device
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd platform::kbd_backlight set 0";
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd platform::kbd_backlight";
            }
            {
              timeout = 180;
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s s 50%-";
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
            }
            {
              timeout = 360;
              on-timeout = "loginctl lock-session";
              on-resume = "";
            }
            {
              timeout = 900;
              on-timeout = "systemctl suspend";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
      };
    };
}

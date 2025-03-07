{
  pkgs,
  inputs,
  config,
  lib,
  username,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../common/desktop.nix
    ../common/nixos/laptop.nix
    ../common/nixos/hyprland.nix
  ];

  specialisation."gaming".configuration = {
    imports = [ ../common/nixos/gaming.nix ];
    environment.etc."gaming".text = "gaming";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  networking.firewall.enable = lib.mkForce true;

  console.earlySetup = true;

  # Personal configurations
  syde = {
    hardware = {
      nvidia.enable = true;
      amd = {
        cpu.enable = true;
        gpu.enable = true;
      };
    };
  };

  programs = {
    wireshark.enable = true;
  };

  services = {
    tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
    };

    syncthing.enable = true;

    kanata = {
      enable = true;

      keyboards.laptop-keyboard = {
        config = # lisp
          ''
            (defsrc
              caps a s d f j k l ;
            )
            (defvar
              tap-time 250
              hold-time 250
              shift-time 180
            )

            (defalias
              a (tap-hold $tap-time $hold-time a lmet)
              s (tap-hold $tap-time $hold-time s lalt)
              d (tap-hold $tap-time $hold-time d lctl)
              f (tap-hold $shift-time $shift-time f lsft)

              j (tap-hold $shift-time $shift-time j rsft)
              k (tap-hold $tap-time $hold-time k lctl)
              l (tap-hold $tap-time $hold-time l lalt)
              ; (tap-hold $tap-time $hold-time ; rmet)
            )

            (deflayer default-layer
              esc @a @s @d @f @j @k @l @;
            )
          '';
        extraDefCfg = "process-unmapped-keys yes";
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];
      };
    };

    xserver.xkb = {
      layout = "us(colemak_dh),dk";
      options = "caps:escape,grp:rctrl_toggle";
    };
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

  home-manager.users.${username} = {
    services.hypridle.settings.listener =
      let
        brightnessctl = lib.getExe pkgs.brightnessctl;
      in
      [
        # Turn off keyboard backlight on idle.
        {
          timeout = 60;
          # NOTE: name of device is specific for this device
          on-timeout = "${brightnessctl} -sd platform::kbd_backlight set 0";
          on-resume = "${brightnessctl} -rd platform::kbd_backlight";
        }
      ];
  };
}

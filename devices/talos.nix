{
  pkgs,
  inputs,
  lib,
  username,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    ../common/desktop.nix
    ../common/nixos/laptop.nix
    ../common/nixos/hyprland.nix
  ];

  specialisation."gaming".configuration = {
    imports = [ ../common/nixos/gaming.nix ];
    environment.etc."specialisation".text = "gaming";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];

  syde.hardware.amd.cpu.enable = true;
  syde.hardware.amd.gpu.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = 1;

  # Personal configurations
  programs = {
    wireshark.enable = true;
    partition-manager.enable = true;
  };

  hardware.framework.laptop13.audioEnhancement.enable = true;

  users.users.${username}.extraGroups = [ "libvirtd" ];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services = {
    ratbagd.enable = true;
    upower.enable = true;

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
          "/dev/input/by-id/usb-CHICONY_HP_Basic_USB_Keyboard-event-kbd"
        ];
      };
    };

    xserver.xkb = {
      layout = "us,dk";
      variant = "colemak_dh,";
      options = "caps:escape,grp:rctrl_toggle";
    };
  };

  networking.wireguard.enable = true;

  # Filesystems
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  systemd.services.framework-power = {
    description = "set framework battery limit";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.framework-tool} --charge-limit 80";
    };
  };

  home-manager.users.${username} = {
    programs.hyprlock.settings.auth.fingerprint.enabled = true;

    services.hypridle.settings.listener =
      let
        brightnessctl = lib.getExe pkgs.brightnessctl;
      in
      [
        # Turn off keyboard backlight on idle.
        {
          timeout = 60;
          # NOTE: name of device is specific for this device
          on-timeout = "${brightnessctl} -sd *::kbd_backlight set 0";
          on-resume = "${brightnessctl} -rd *::kbd_backlight";
        }
      ];
  };
}

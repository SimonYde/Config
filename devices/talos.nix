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
    inputs.lanzaboote.nixosModules.lanzaboote
    ../common/desktop.nix
  ];

  specialisation."gaming".configuration = {
    syde.gaming.enable = true;
    environment.etc."specialisation".text = "gaming";
  };

  syde = {
    development.enable = true;
    hardware = {
      laptop.enable = true;
      amd = {
        cpu.enable = true;
        gpu.enable = true;
      };
    };
  };

  users.users.syde.packages = with pkgs; [
    vscode
    cpeditor
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = 1;

  environment.systemPackages = with pkgs; [
    sbctl # Secure boot
  ];

  programs = {
    hyprland.enable = true;
    partition-manager.enable = true;
    virt-manager.enable = true;
    wireshark.enable = true;
    sniffnet.enable = true;
  };

  hardware.framework.laptop13.audioEnhancement = {
    enable = true;
    rawDeviceName = "alsa_output.pci-0000_c1_00.6.HiFi__Speaker__sink";
  };

  networking.wireguard.enable = true;

  services = {
    fwupd.enable = true;
    hardware.openrgb.enable = true;
    ratbagd.enable = true;
    upower.enable = true;

    syncthing.enable = true;

    kanata = {
      enable = true;

      keyboards.home-row-mods = {
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
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd" # laptop keyboard
          "/dev/input/by-id/usb-Logitech_G512_Carbon_Linear_0A81375E3333-event-kbd"
        ];
      };
    };

    xserver.xkb = {
      layout = "us,dk";
      variant = "colemak_dh,";
      options = "caps:escape,grp:rctrl_toggle";
    };
  };

  # Filesystems
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  systemd.services.framework-power = {
    description = "set framework battery limit";
    wantedBy = [
      "basic.target"
      "suspend.target"
      "hibernate.target"
    ];
    after = [
      "sysinit.target"
      "local-fs.target"
      "suspend.target"
      "hibernate.target"
    ];
    before = [ "basic.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.framework-tool} --charge-limit 80";
    };
  };

  home-manager.users.${username} = {
    programs.hyprlock.settings.auth.fingerprint.enabled = true;
  };
}

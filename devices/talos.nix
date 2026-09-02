{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    inputs.lanzaboote.nixosModules.lanzaboote
    ../common/desktop.nix
  ];

  system.stateVersion = "25.11";

  specialisation."gaming".configuration = {
    syde.gaming.enable = true;
    environment.etc."specialisation".text = "gaming";
  };

  age.secrets."eduroam" = {
    file = "${inputs.secrets}/eduroam.age";
  };

  systemd.tmpfiles.rules = [
    "L+ /var/lib/iwd/eduroam.8021x - - - - ${config.age.secrets.eduroam.path}"
  ];

  syde = {
    ctf.enable = false;
    development.enable = true;

    hardware = {
      laptop.enable = true;
      amd = {
        cpu.enable = true;
        gpu.enable = true;
      };
    };
  };

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };

    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = 1;

  environment.systemPackages = with pkgs; [
    sbctl # Secure boot
    virtiofsd
  ];

  fonts.fontconfig.subpixel.rgba = "rgb";

  programs = {
    hyprland.enable = true;
    partition-manager.enable = true;
    virt-manager.enable = true;
  };

  hardware.framework.laptop13.audioEnhancement = {
    enable = true;
    rawDeviceName = "alsa_output.pci-0000_c1_00.6.analog-stereo";
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
        config = # scheme
          ''
            (defsrc
              tab           q w e r t y u i o p
              caps          a s d f g h j k l ;
              IntlBackslash z x c v b n m
            )

            (defvar
              tap-time 250
              hold-time 250
              shift-time 180
            )

            (defalias
              a (tap-hold $tap-time $hold-time a lmet)
              r (tap-hold $tap-time $hold-time r lalt)
              s (tap-hold $tap-time $hold-time s lctl)
              t (tap-hold $shift-time $shift-time t lsft)

              n (tap-hold $shift-time $shift-time n rsft)
              e (tap-hold $tap-time $hold-time e lctl)
              i (tap-hold $tap-time $hold-time i lalt)
              o (tap-hold $tap-time $hold-time o rmet)
            )

            (deflayer default-layer
                   tab q  w  f  p  b j l  u  y  ;
                   esc @a @r @s @t g m @n @e @i @o
                   z   x  c  d  v  IntlBackslash k h
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
      layout = "eu";
      variant = "";
      options = "";
    };

    pipewire = {
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/alsa-config.conf" ''
          monitor.alsa.properties = {
            alsa.use-ucm = false
          }
        '')
      ];
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

  # swapDevices = [
  #   {
  #     randomEncryption = true;
  #     device = "/dev/disk/by-partuuid/79a4745c-83a5-452c-85b2-91fd7f001200";
  #   }
  # ];

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
}

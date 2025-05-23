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

  services.logind.lidSwitch = "ignore";
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
      layout = "us,dk";
      variant = "colemak_dh,";
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
}

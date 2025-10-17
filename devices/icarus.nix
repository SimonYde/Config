{
  pkgs,
  username,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ../common/desktop.nix
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # Personal configurations
  syde = {
    development.enable = true;
    gaming.enable = true;
    hardware = {
      nvidia = {
        enable = true;
        dedicated = true;
      };

      amd.cpu.enable = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  environment.systemPackages = with pkgs; [
    sbctl

    idasen # ikea table
  ];

  fonts.fontconfig.subpixel.rgba = "rgb";

  programs = {
    hyprland.enable = true;
    partition-manager.enable = true;
    wireshark.enable = true;
  };

  services = {
    safeeyes.enable = false;
    ratbagd.enable = true;
    syncthing.enable = true;

    xserver.xkb.layout = "eu";

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled", ATTR{driver/1-1/power/wakeup}="disabled"
    '';

    pipewire = {
      extraConfig = {
        pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 128;
            "default.clock.min-quantum" = 128;
            "default.clock.max-quantum" = 128;
          };
        };

        pipewire-pulse."92-low-latency" = {
          "context.properties" = [
            {
              name = "libpipewire-module-protocol-pulse";
              args = { };
            }
          ];
          "pulse.properties" = {
            "pulse.min.req" = "128/48000";
            "pulse.default.req" = "128/48000";
            "pulse.max.req" = "128/48000";
            "pulse.min.quantum" = "128/48000";
            "pulse.max.quantum" = "128/48000";
          };
          "stream.properties" = {
            "node.latency" = "128/48000";
            "resample.quality" = 1;
          };
        };
      };

      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-audient-id14.conf" ''
          monitor.alsa.rules = [
            {
              matches = [{ node.name = "alsa_output.usb-Audient_Audient_iD14-00.*" }]
              actions = {
                update-props = {
                  audio.allowed-rates = [44100, 48000, 88200, 96000, 176400, 192000]
                }
              }
            }
          ]
        '')
      ];
    };

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

  home-manager.users.${username} = {
    programs.hyprlock.settings.general.screencopy_mode = 1; # NOTE: nvidia problems

    fonts.fontconfig = {
      antialiasing = true;
      subpixelRendering = "rgb";
    };
  };
}

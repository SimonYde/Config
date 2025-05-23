{
  pkgs,
  username,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../common/desktop.nix
    ../common/nixos/hyprland.nix
    ../common/nixos/gaming.nix
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  # Personal configurations
  syde = {
    hardware = {
      nvidia = {
        enable = true;
        dedicated = true;
      };

      amd.cpu.enable = true;
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

  programs.partition-manager.enable = true;

  services.pipewire = {
    extraConfig = {
      pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 64;
          "default.clock.min-quantum" = 64;
          "default.clock.max-quantum" = 64;
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
          "pulse.min.req" = "64/48000";
          "pulse.default.req" = "64/48000";
          "pulse.max.req" = "64/48000";
          "pulse.min.quantum" = "64/48000";
          "pulse.max.quantum" = "64/48000";
        };
        "stream.properties" = {
          "node.latency" = "64/48000";
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

  services = {
    safeeyes.enable = true;
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

  home-manager.users.${username} = {

    services.blanket.enable = true;

    programs.hyprlock.settings.general.screencopy_mode = 1; # NOTE: nvidia problems
  };
}

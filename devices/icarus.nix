{
  pkgs,
  username,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) getExe mkForce;
in
{
  imports = [
    ../common/desktop.nix
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # Personal configurations
  syde = {
    audio-production.enable = true;
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
    loader.systemd-boot.enable = mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  environment.systemPackages = with pkgs; [
    sbctl
    distrobox
    distrobox-tui
  ];

  fonts.fontconfig.subpixel.rgba = "rgb";

  programs = {
    hyprland.enable = true;
    partition-manager.enable = true;
    wireshark.enable = false;
  };

  services = {
    safeeyes.enable = false;
    ratbagd.enable = true;
    syncthing.enable = true;

    xserver.xkb.layout = "eu";

    udev.extraRules = # udev
      ''
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

  home-manager.users.${username} =
    let
      idasen = getExe pkgs.idasen;
      adjust-table =
        pkgs.writers.writeNuBin "adjust-table" # nu
          ''
            use std/log
            let config = open ~/.config/idasen/idasen.yaml
            log info "open config"
            let height = ${idasen} height | parse "{height} meters" | first | get height | into float
            log info $"got desk height: ($height)"

            if $height == $config.positions.sit {
              log info $"moving desk to standing position"
              ${idasen} stand
            } else {
              log info $"moving desk to sitting position"
              ${idasen} sit
            }
          '';
    in
    {
      home.packages = [
        pkgs.idasen
        adjust-table
      ];

      services.hypridle.settings = {
        general.after_sleep_cmd = mkForce "systemctl --user restart hyprsunset.service";
        listener = mkForce [ ];
      };

      systemd.user = {
        timers.autoadjust-table = {

          Unit.Description = "Cycle table height";

          Timer.OnUnitActiveSec = "20min";

          Install.WantedBy = [ "timers.target" ];
        };

        services.autoadjust-table = {
          Unit.Description = "Cycle table height";

          Service = {
            Type = "oneshot";
            ExecStart = getExe adjust-table;
          };
        };
      };
    };


  home-manager.users.root = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "backup" = {
          port = 20001;
          hostname = "tmcs.davvol.dk";
          user = "tmcs";
          identityFile = "/etc/ssh/ssh_hestia_ed25519_key";
          serverAliveInterval = 60;
          serverAliveCountMax = 240;
        };
      };
    };
  };
}

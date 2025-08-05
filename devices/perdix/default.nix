{
  pkgs,
  inputs, lib,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../../common/server.nix
    ./acme.nix
    ./atuin.nix

    ./kanidm.nix
    ./grafana
  ];

  system.stateVersion = "25.05";

  # Personal configurations
  syde = {
    server.baseDomain = "simonyde.com";

    development.enable = true;

    hardware = {
      amd.cpu.enable = true;
      nvidia.enable = false;
    };
  };

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

  hardware.enableRedistributableFirmware = true;

  services = {
    logind.lidSwitch = "ignore";

    nginx = {
      enable = true;

      virtualHosts."edgeos.ts.simonyde.com".locations."/" = {
        proxyPass = "https://192.168.1.1:8443";
        proxyWebsockets = true;
      };
    };

    syncthing.enable = true;
    zfs.autoScrub.enable = true;

    networkd-dispatcher = {
      enable = true;
      rules.tailscale-perf = {
        onState = [ "routable" ];
        script = ''
          #!${pkgs.runtimeShell}
          ${lib.getExe pkgs.ethtool} -K eno1 rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };
  };

  networking = {
    # $ head -c 4 /dev/urandom | xxd -p
    hostId = "d10ef1c6";

    useDHCP = false;
    firewall.allowedUDPPorts = [ 5353 ]; # mDNS

    nameservers = [
      # dns0.eu
      "193.110.81.0"
      "185.253.5.0"
      # cloudflare
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  systemd.network = {
    enable = true;

    networks.wired = {
      name = "en*";
      DHCP = "yes";
      domains = [ "home" ];
      networkConfig.MulticastDNS = true;
    };
  };

  fileSystems = {
    "/" = {
      neededForBoot = true;
      device = "zpool/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/nix" = {
      device = "zpool/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var" = {
      device = "zpool/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/home" = {
      device = "zpool/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/49B2-C8B0";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
}

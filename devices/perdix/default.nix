{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (config.syde) server;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../../common/server.nix
    ./acme.nix
    ./atuin.nix

    ./kanidm.nix
    ./grafana
    ./languagetool.nix
  ];

  system.stateVersion = "25.05";

  # Personal configurations
  syde = {
    server.baseDomain = "simonyde.com";

    email = {
      enable = true;
      fromAddress = "services@tmcs.dk";
      toAddress = "services@tmcs.dk";
      smtpServer = "send.one.com";
      smtpUsername = "services@tmcs.dk";
      smtpPasswordPath = config.age.secrets.emailPassword.path;
    };

    development.enable = false;
    monitoring.enable = true;

    hardware = {
      amd.cpu.enable = true;
      nvidia.enable = true;
    };

    zfs.enable = true;
  };

  age.secrets.emailPassword = {
    file = "${inputs.secrets}/oneEmailPassword.age";
    owner = server.user;
    group = server.group;
    mode = "0440";
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
    logind.settings.Login.HandleLidSwitch = "ignore";

    nginx = {
      enable = true;

      virtualHosts."edgeos.ts.simonyde.com".locations."/" = {
        proxyPass = "https://192.168.1.1:8443";
        proxyWebsockets = true;
      };
    };

    languagetool.enable = true;

    syncthing.enable = true;
    fstrim.enable = true;
    postgresql.package = lib.mkForce pkgs.postgresql_18;

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
      "194.242.2.4" # Mullvad base
      "86.54.11.13" # DNS4EU
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

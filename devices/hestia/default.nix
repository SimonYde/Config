{
  pkgs,
  inputs,
  config,
  username,
  ...
}:
{
  imports = [
    ../../common/server.nix

    ./acme.nix
    ./backup.nix
    ./collabora-online
    ./fail2ban.nix
    ./immich.nix
    ./jellyfin.nix
    ./nextcloud.nix
    ./smartd.nix
    ./vaultwarden.nix
  ];

  system.stateVersion = "25.11";

  syde = {
    email = {
      enable = true;
      fromAddress = "services@tmcs.dk";
      toAddress = "services@tmcs.dk";
      smtpServer = "send.one.com";
      smtpUsername = "services@tmcs.dk";
      smtpPasswordPath = config.age.secrets.emailPassword.path;
    };

    hardware.amd = {
      cpu.enable = true;
      gpu.enable = true;
    };

    monitoring.enable = true;

    services.fail2ban.enable = true;

    server.baseDomain = "tmcs.dk";

    zfs.enable = true;
  };


  age.secrets.emailPassword = {
    file = "${inputs.secrets}/oneEmailPassword.age";
    owner = username;
    group = "users";
    mode = "0440";
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];

    kernelModules = [ "msr" ];
  };

  hardware.enableRedistributableFirmware = true;

  services = {
    fstrim.enable = true;

    immich = {
      enable = true;
      mediaDir = "/mnt/tank/immich";
    };

    jellyfin = {
      enable = true;
      mediaDir = "/mnt/tank/jellyfin";
    };

    nginx.enable = true;
    nextcloud.enable = true;
  };

  networking = {
    hostId = "ef847b13";

    useDHCP = false;
    firewall.allowedUDPPorts = [ 5353 ]; # mDNS

    nameservers = [
      "193.110.81.0"
      "185.253.5.0"
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

  systemd.services.disable-c6 = {
    description = "Ryzen Disable C6";
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
      Type = "oneshot";
      ExecStart = "${pkgs.zenstates}/bin/zenstates --c6-disable";
    };

    unitConfig = {
      DefaultDependencies = "no";
    };
  };

  fileSystems = {
    "/" = {
      neededForBoot = true;
      device = "os-pool/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var" = {
      device = "os-pool/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/nix" = {
      device = "os-pool/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/home" = {
      device = "os-pool/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/mnt/tank/immich" = {
      device = "tank/immich";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/mnt/tank/jellyfin" = {
      device = "tank/jellyfin";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/mnt/tank/nextcloud" = {
      device = "tank/nextcloud";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/4611-5C65";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
}

{
  pkgs,
  inputs,
  config,
  username,
  ...
}:
{
  imports = [
    # inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate

    ../../common/server.nix

    ./acme.nix
    ./backup.nix
    ./fail2ban.nix
    ./immich.nix
    ./jellyfin.nix
    ./nextcloud.nix
    ./postgresql.nix
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

    services.fail2ban.enable = true;

    server.baseDomain = "tmcs.dk";
  };

  networking.hostId = "ef847b13";

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

  hardware = {
    enableAllHardware = true;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  services = {
    zfs.autoScrub.enable = true;

    immich = {
      enable = false;
      mediaDir = "/mnt/tank/immich";
    };

    jellyfin = {
      enable = true;
      mediaDir = "/mnt/tank/jellyfin";
    };

    nginx.enable = true;
    nextcloud.enable = true;
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

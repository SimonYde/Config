{ inputs, config, username, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate

    ../../common/server.nix
    ./acme.nix
    ./postgresql.nix
    ./vaultwarden.nix
    ./nextcloud.nix
  ];

  system.stateVersion = "25.11";

  syde = {
    email = {
      enable = true;
      fromAddress = "s@tmcs.dk";
      toAddress = "s@tmcs.dk";
      smtpServer = "send.one.com";
      smtpUsername = "s@tmcs.dk";
      smtpPasswordPath = config.age.secrets.emailPassword.path;
    };

    hardware.amd = {
      cpu.enable = true;
      gpu.enable = true;
    };

    server.baseDomain = "tmcs.dk";
  };

  networking.hostId = "ef847b13";

  age.secrets.emailPassword = {
    file = ../../secrets/oneEmailPassword.age;
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
  };

  hardware = {
    enableAllHardware = true;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  services = {
    zfs.autoScrub.enable = true;

    nginx.enable = true;
    nextcloud.enable = true;
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

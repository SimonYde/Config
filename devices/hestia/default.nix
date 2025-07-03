{ ... }:
{
  imports = [
    ../../common/server.nix
  ];

  system.stateVersion = "25.11";

  syde.hardware.amd = {
    cpu.enable = true;
    gpu.enable = true;
  };

  networking.hostId = "ef847b13";

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

  fileSystems = {
    "/" = {
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

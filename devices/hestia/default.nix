{
  pkgs,
  inputs,
  config,
  username,
  lib,
  ...
}:
{
  imports = [
    ../../common/server.nix

    ./acme.nix
    ./backup.nix
    ./collabora-online.nix
    ./fail2ban.nix
    ./immich.nix
    ./jellyfin.nix
    ./opencloud.nix
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

    kernelModules = [
      "msr" # c6-disable
    ];
  };

  hardware.enableRedistributableFirmware = true;

  services = {
    fstrim.enable = true;

    immich = {
      enable = false;
      mediaDir = "/mnt/tank/immich";
    };

    jellyfin = {
      enable = true;
      mediaDir = "/mnt/tank/jellyfin";
    };

    opencloud = {
      enable = false;
      stateDir = "/mnt/tank/opencloud";
    };
    nginx.enable = true;
    nextcloud.enable = true;

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
    hostId = "ef847b13";

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
      device = "/dev/disk/by-uuid/5d3bb363-6dc9-49e6-890e-7e0131382acc";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/5d3bb363-6dc9-49e6-890e-7e0131382acc";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/5d3bb363-6dc9-49e6-890e-7e0131382acc";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7A05-D173";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
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
  };

  swapDevices = [ { device = "/dev/disk/by-partuuid/670576a9-57c7-45b6-a40c-ca43401fbba9"; } ];
}

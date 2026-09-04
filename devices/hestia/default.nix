{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.syde) server;
in
{
  imports = [
    ../../common/server.nix

    ./acme.nix
    ./backup.nix
    ./blackbox_exporter.nix
    ./collabora-online.nix
    ./fail2ban.nix
    ./immich.nix
    ./jellyfin.nix
    ./mealie.nix
    ./nextcloud.nix
    ./paperless.nix
    ./smartd.nix
    ./vaultwarden.nix

    ./oauth2-proxy.nix
    ./bitmagnet.nix
    ./prowlarr.nix
    ./sonarr.nix
    ./radarr.nix
    ./lidarr.nix
    ./bazarr.nix
    ./seerr.nix
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
    server.authDomain = "auth.simonyde.com";

    zfs.enable = true;
  };

  age.secrets.sambaPassword.file = "${inputs.secrets}/sambaPassword.age";
  age.secrets.perdixSambaCredentials.file = "${inputs.secrets}/perdixSambaCredentials.age";

  age.secrets.emailPassword = {
    file = "${inputs.secrets}/oneEmailPassword.age";
    owner = server.user;
    group = server.group;
    mode = "0440";
  };

  age.secrets.wireguardHestia = {
    file = "${inputs.secrets}/wireguardHestia.age";
  };

  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112"
  ];

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
    fwupd.enable = true;
    fstrim.enable = true;

    immich = {
      enable = true;
      mediaDir = "/mnt/tank/immich";
    };

    jellyfin = {
      enable = true;
      mediaDir = "/mnt/tank/jellyfin";
    };

    mealie.enable = true;

    paperless = {
      enable = true;
      mediaDir = "/mnt/tank/paperless";
    };

    collabora-online.enable = true;
    nginx.enable = true;
    nextcloud.enable = true;
    samba.enable = true;
    syncthing.enable = true;

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

    wireguard-netns =
      let
        networks = import "${inputs.secrets}/networks.nix";
        wg_extern = networks.wg_extern;
      in
      {
        enable = true;
        namespace = "wg_extern";
        configFile = config.age.secrets.wireguardHestia.path;
        inherit (wg_extern) privateIP dnsIP;
      };
  };

  networking = {
    hostId = "ef847b13";

    useDHCP = false;
    firewall.allowedUDPPorts = [ 5353 ]; # mDNS
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

    "/mnt/tank/paperless" = {
      device = "tank/paperless";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/mnt/tank/immich" = {
      device = "tank/immich";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/media/Torrents" = {
      device = "//100.64.0.2/Media";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        in
        [
          "${automount_opts},credentials=${config.age.secrets.perdixSambaCredentials.path},uid=${toString config.users.users.${server.user}.uid},gid=${toString config.users.groups.${server.group}.gid}"
          "nofail"
        ];
    };
  };

  swapDevices = [ { device = "/dev/disk/by-partuuid/670576a9-57c7-45b6-a40c-ca43401fbba9"; } ];
}

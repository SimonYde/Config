{
  lib,
  pkgs,
  config,
  inputs,
  username,
  ...
}:

let
  inherit (lib)
    getExe
    mkDefault
    mapAttrs
    ;
  keys = import ../keys.nix;
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.default
    ./base/nix-settings.nix

    ./services
    ./hardware
    ./applications
  ];

  system.stateVersion = mkDefault "25.05";

  i18n.defaultLocale = "en_GB.UTF-8";

  time.timeZone = mkDefault "Europe/Copenhagen";

  documentation.nixos.enable = false;

  boot = {
    tmp = {
      useTmpfs = true;
      tmpfsSize = "100%";
    };

    initrd.systemd = {
      enable = true;
      emergencyAccess = true;
    };

    # enable TCP BBR for hopefully better utilization
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
  };

  zramSwap.enable = true;

  nix = {
    package = lib.mkDefault pkgs.lixPackageSets.latest.lix;

    channel.enable = false;
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    distributedBuilds = true;
    daemonCPUSchedPolicy = "batch";
    settings.trusted-users = [ username ];
  };

  programs = {
    command-not-found.enable = false;

    ssh.knownHosts = mapAttrs (_: key: { publicKey = key; }) keys;

    nh = {
      enable = true;

      flake = "/home/${username}/Config";

      clean = {
        enable = true;
        extraArgs = "--keep 2 --nogcroots";
        dates = "daily";
      };
    };
  };

  networking.nftables.enable = true;

  # Use Rust implementation of `sudo`
  security = {
    sudo.enable = false;
    sudo-rs.enable = true;
  };

  services = {
    orca.enable = false;
    speechd.enable = false;

    dbus.implementation = "broker";

    journald.extraConfig = "SystemMaxUse=100M";

    openssh = {
      enable = true;

      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        AllowAgentForwarding = true;
      };
    };

    tailscale.enable = true;
  };

  environment.shells = [ pkgs.nushell-wrapped ];
  environment.localBinInPath = true;

  users = {
    mutableUsers = mkDefault false;

    users = {
      root = {
        shell = pkgs.nushell-wrapped;

        openssh.authorizedKeys.keys = [ keys.syde ];
      };

      ${username} = {
        isNormalUser = true;
        shell = pkgs.nushell-wrapped;
        hashedPasswordFile = config.age.secrets.pc-password.path;
        description = "Simon Yde";
        extraGroups = [ "wheel" ];

        openssh.authorizedKeys.keys = [ keys.syde ];
      };
    };
  };

  home-manager = {
    backupFileExtension = "backup";

    extraSpecialArgs = { inherit inputs; };

    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username}.imports = [ ./home-manager ];
    users.root.imports = [
      ./home-manager
      ./home-manager/root.nix
    ];
  };

  age = {
    ageBin = getExe pkgs.rage;

    secrets = {
      wireguard.file = "${inputs.secrets}/wireguard.age";
      pc-password.file = "${inputs.secrets}/pc-password.age";
    };
  };

  systemd = {
    oomd = {
      enableUserSlices = true;
      enableRootSlice = true;
    };

    # Just in case, reserve memory for sshd
    services.sshd.serviceConfig.MemoryMin = "100M";

    # Clean up /var/tmp/nix way more often
    tmpfiles.rules = [ "d /var/tmp/nix 1777 root root 1d" ];
  };

  system = {
    nixos =
      let
        meta = inputs.nixpkgs;
      in
      {
        versionSuffix = ".${
          lib.substring 0 8 (meta.lastModifiedDate or meta.nixpkgs.lastModified or "19700101")
        }.${meta.shortRev or "dirty"}";
        revision = meta.rev or "dirty";
      };
    configurationRevision = inputs.self.rev or "dirty";

    # Disable some unnecessary tools
    tools = {
      nixos-build-vms.enable = false;
      nixos-enter.enable = false;
      nixos-generate-config.enable = false;
      nixos-install.enable = false;
      nixos-option.enable = false;
    };
  };
}

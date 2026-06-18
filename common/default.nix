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
    inputs.ncro.nixosModules.default

    ./base/nix-settings.nix

    ./services
    ./hardware
    ./applications
  ];

  system.stateVersion = mkDefault (throw "stateVersion should be defined.");

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
    settings = {
      trusted-users = [ username ];
      substituters = lib.mkForce [
        "http://localhost${config.services.ncro.settings.server.listen}"
      ];
    };
  };

  programs = {
    command-not-found.enable = false;

    fish.enable = true; # TODO(2026-03-10 Simon Yde): for system completions.

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

    ncro = {
      enable = true;

      settings = {
        server = {
          listen = ":10100";
        };

        upstreams = [
          {
            url = "https://cache.nixos.org";
            priority = 10;
            public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
          }
          {
            url = "https://nix-community.cachix.org";
            priority = 20;
            public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
          }
          {
            url = "https://attic.xuyh0120.win/lantian";
            priority = 30;
            public_key = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
          }
        ];
      };
    };
  };

  environment.shells = [ pkgs.nushell-wrapped ];
  environment.localBinInPath = true;
  environment.sessionVariables = {
    NH_SHOW_ACTIVATION_LOGS = 1;
  };

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
    users.root.imports = [ ./home-manager ];
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
    # Better version tracking
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

{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

let
  inherit (lib)
    getExe
    mkDefault
    mkOption
    mkIf
    types
    mapAttrs
    ;
  inherit (config.syde) user;
  keys = import ../../keys.nix;
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.default
    ../base/nix-settings.nix
    ../../overlays.nix

    ./gaming.nix
    ./syncthing.nix
    ./hardware
  ];

  config = {
    system.stateVersion = "24.11";

    i18n.defaultLocale = "en_GB.UTF-8";

    time.timeZone = mkDefault "Europe/Copenhagen";

    boot = {
      tmp = {
        useTmpfs = true;
        tmpfsSize = "100%";
      };

      initrd.systemd = {
        enable = true;
        emergencyAccess = true;
      };
    };

    services = {
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
        };
      };

      journald.extraConfig = "SystemMaxUse=100M";

      ollama = {
        openFirewall = true;
        host = "[::]";
      };

      tailscale = {
        extraUpFlags = [
          "--ssh"
          "--operator=${user}"
        ];
        useRoutingFeatures = "both";
        openFirewall = true;
        extraDaemonFlags = [ "--no-logs-no-support" ];
      };
    };

    nix = {
      nixPath = [ "nixpkgs=flake:nixpkgs" ];
      channel.enable = false;
      package = pkgs.lix;
      settings.trusted-users = [ user ];
    };

    documentation.nixos.enable = false;

    programs = {
      command-not-found.enable = false;

      ssh.knownHosts = mapAttrs (_: key: { publicKey = key; }) keys;

      nh = {
        enable = true;

        flake = "/home/${user}/Config";
        clean = {
          enable = true;
          extraArgs = "--keep 2 --keep-since 1d";
          dates = "daily";
        };
      };
    };

    networking.wg-quick.interfaces = mkIf config.networking.wireguard.enable {
      proton = {
        autostart = false;
        address = [ "10.2.0.2/32" ];
        dns = [ "10.2.0.1" ];
        privateKeyFile = config.age.secrets.wireguard.path;
        peers = [
          {
            publicKey = "XPVCz7LndzqWe7y3+WSo51hvNOX8nX5CTwVTWhzg8g8=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "149.88.27.234:51820";
          }
        ];
      };
    };

    # Use Rust implementation of `sudo`
    security = {
      sudo.enable = false;
      sudo-rs.enable = true;
    };

    environment.shells = [ pkgs.nushell-wrapped ];

    users = {
      mutableUsers = false;

      users = {
        root = {
          shell = pkgs.nushell-wrapped;

          openssh.authorizedKeys.keys = [
            keys.icarus
            keys.perdix
          ];
        };

        ${user} = {
          isNormalUser = true;
          shell = pkgs.nushell-wrapped;
          hashedPasswordFile = config.age.secrets.pc-password.path;
          description = "Simon Yde";

          extraGroups = [
            (mkIf config.virtualisation.docker.enable "docker")
            (mkIf config.services.syncthing.enable "syncthing")
            "wheel"
          ];

          openssh.authorizedKeys.keys = [
            keys.icarus
            keys.perdix
          ];
        };
      };
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${user}.imports = [ ../home-manager ];
      extraSpecialArgs = {
        inherit inputs;
      };
    };

    age = {
      identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];
      ageBin = getExe pkgs.rage;
      secrets = {
        wireguard.file = ../../secrets/wireguard.age;
        pc-password.file = ../../secrets/pc-password.age;
        tailscale.file = ../../secrets/tailscale.age;
      };
    };

    systemd = {
      oomd = {
        enableUserSlices = true;
        enableRootSlice = true;
      };
      services.sshd.serviceConfig.MemoryMin = "100M";
    };
  };

  options.syde = {
    user = mkOption {
      type = types.str;
      default = "syde";
      description = "Username of primary system user.";
    };
  };
}

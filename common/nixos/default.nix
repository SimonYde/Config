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
    types
    mapAttrs
    ;
  inherit (config.syde) user;
  keys = import ../../keys.nix;
in
{
  config = {
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
    };
    i18n.defaultLocale = "en_GB.UTF-8";

    system.stateVersion = "24.11";

    nix = {
      nixPath = [ "nixpkgs=flake:nixpkgs" ];
      channel.enable = false;
      package = pkgs.lix;
      settings.trusted-users = [ user ];
    };

    documentation.nixos.enable = false;

    programs.command-not-found.enable = false;
    programs.ssh.knownHosts = mapAttrs (_: key: { publicKey = key; }) keys;

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
          extraGroups = [ "wheel" ];
          hashedPasswordFile = config.age.secrets.pc-password.path;
          description = "Simon Yde";

          openssh.authorizedKeys.keys = [
            keys.icarus
            keys.perdix
          ];
        };
      };
    };

    home-manager = {
      useGlobalPkgs = true;
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

    time.timeZone = mkDefault "Europe/Copenhagen";

  };

  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.default
    ../base/nix-settings.nix
    ../magic-gc/nixos.nix
    ../../overlays.nix

    ./gaming.nix
    ./desktops
    ./programs
    ./hardware
    ./services
  ];

  options.syde = {
    user = mkOption {
      type = types.str;
      default = "syde";
      description = "Username of primary system user.";
    };
  };
}

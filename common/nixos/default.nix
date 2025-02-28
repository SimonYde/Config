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
    mkOption
    types
    ;
  inherit (config.syde) user;
in
{
  config = {

    system.stateVersion = "24.11";

    nixpkgs.flake = {
      setNixPath = true;
    };

    nix.channel.enable = false;
    nix.package = pkgs.lix;
    nix.settings.trusted-users = [ user ];

    documentation.nixos.enable = false;

    programs.command-not-found.enable = false;
    security.sudo.enable = false;
    security.sudo-rs.enable = true;

    users = {
      mutableUsers = false;

      users = {
        root = {
          shell = pkgs.nushell-wrapped;
        };

        ${user} = {
          shell = pkgs.nushell-wrapped;
          isNormalUser = true;
          description = "Simon Yde";
          extraGroups = [ "wheel" ];
          hashedPasswordFile = config.age.secrets.pc-password.path;
        };
      };
    };

    environment.shells = [ pkgs.nushell-wrapped ];

    age.identityPaths = [ "/home/${config.syde.user}/.ssh/id_ed25519" ];
    age.ageBin = getExe pkgs.rage;
    age.secrets = {
      wireguard.file = ../../secrets/wireguard.age;
      pc-password.file = ../../secrets/pc-password.age;
      tailscale.file = ../../secrets/tailscale.age;
    };

    home-manager = {
      useGlobalPkgs = true;
      users.${user}.imports = [ ../home-manager ];
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };

  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.default
    ../base/nix-settings.nix
    ../magic-gc/nixos.nix
    ../../overlays.nix

    ./modules/gaming.nix
    ./modules/pc.nix
    ./modules/desktops
    ./modules/programs
    ./modules/hardware
    ./modules/services
  ];

  options.syde = {
    user = mkOption {
      type = types.str;
      default = "syde";
      description = "Username of primary system user.";
    };
  };
}

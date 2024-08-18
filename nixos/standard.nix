{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  config = {
    nixpkgs.config.allowUnfree = true;
  };

  imports = [
    ../overlays.nix

    ./modules/gaming.nix
    ./modules/agenix.nix
    ./modules/pc.nix
    ./modules/wsl.nix
    ./modules/desktops
    ./modules/programs
    ./modules/hardware
    ./modules/services
  ];

  options.syde = {
    shell = mkOption {
      type = types.str;
      default = "fish";
    };
    user = mkOption {
      type = types.str;
      default = "syde";
    };
  };
}

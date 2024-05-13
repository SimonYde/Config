{ lib, inputs, pkgs, ... }:

let
  inherit (lib) mkOption types;
in
{
  config = {
    nixpkgs.overlays = [ inputs.nix-ld-rs.overlays.default ];

    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.system}.default
    ];
  };
  imports = [
    inputs.agenix.nixosModules.default
    ./modules/gaming.nix
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

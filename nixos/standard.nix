{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkOption types;
  user = config.syde.user;
  agenix = inputs.agenix;
  system = pkgs.system;
in
{
  config = {
    nixpkgs.overlays = [ inputs.nix-ld-rs.overlays.default ];

    environment.systemPackages = [
      (agenix.packages.${system}.default.override { ageBin = "${pkgs.rage}/bin/rage"; })
    ];

    age.secrets.wireguard.file = ../secrets/wireguard.age;
    age.identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];
  };
  imports = [
    agenix.nixosModules.default
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

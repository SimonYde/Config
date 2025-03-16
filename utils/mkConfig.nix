{
  inputs,
  hostSystem ? builtins.currentSystem,
}:

let
  nixpkgs = import inputs.nixpkgs;
  overlays = import ../overlays.nix { inherit inputs; };

  specialArgs = { inherit inputs; };

  nixpkgsHost = nixpkgs {
    system = hostSystem;
    inherit overlays;
    config.allowUnfree = true;
  };

  mkSystem =
    {
      hostname,
      username ? "syde",
      extraModules ? [ ],
      system ? "x86_64-linux",
    }:
    let
      deviceSpecificConfig = ../devices + "/${hostname}.nix";
      deviceSpecificConfigDir = ../devices + "/${hostname}/default.nix";
      deviceSpecificModules =
        if builtins.pathExists deviceSpecificConfig then
          [ deviceSpecificConfig ]
        else if builtins.pathExists deviceSpecificConfigDir then
          [ deviceSpecificConfigDir ]
        else
          [ ];
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs // {
        inherit username;
      };
      modules =
        [
          {
            nixpkgs = {
              inherit overlays;
              hostPlatform = system;

              config.allowUnfree = true;
            };

            networking.hostName = hostname;
          }
        ]
        ++ deviceSpecificModules
        ++ extraModules;
    };

  mkWslSystem =
    {
      hostname,
      username ? "syde",
    }:
    mkSystem {
      inherit username;
      hostname = "${hostname}-wsl";
      extraModules = [ ../common/wsl.nix ];
    };

  mkHome =
    {
      username,
      homeDirectory ? "/home/${username}",
      extraModules ? [ ],
      system ? "x86_64-linux",
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs { inherit system overlays; };
      modules = [
        ../shared/home/standalone.nix
        {
          home = { inherit username homeDirectory; };
        }
      ] ++ extraModules;
      extraSpecialArgs = specialArgs;
    };
in
{
  inherit
    mkSystem
    mkWslSystem
    mkHome
    ;
  pkgs = nixpkgsHost;
}

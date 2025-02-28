{
  inputs,
  hostSystem ? builtins.currentSystem,
  targetSystems ? [
    "x86_64-linux"
    "aarch64-linux"
  ],
  config ? { },
}:

let
  pkgs = import inputs.nixpkgs { system = hostSystem; };
  nixpkgs = import inputs.nixpkgs;

  nixpkgsBySystem = pkgs.lib.attrsets.genAttrs targetSystems (
    system:
    nixpkgs {
      inherit system;
      config = config // {
        allowUnfree = true;
        cudaSupport = true;
      };
    }
  );
  nixpkgsHost = nixpkgsBySystem.${hostSystem};

  specialArgs = { inherit inputs; };

  mkSystem =
    {
      hostname,
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
      pkgs = nixpkgsBySystem.${system};
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules =
        [
          {
            networking.hostName = hostname;
            nixpkgs.pkgs = pkgs;
          }
        ]
        ++ deviceSpecificModules
        ++ extraModules;
    };

  mkWslSystem =
    { hostname }:
    mkSystem {
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
      pkgs = nixpkgsBySystem.${system};
      modules = [
        ../shared/home/standalone.nix
        {
          home = {
            inherit username homeDirectory;
          };
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
    nixpkgsBySystem
    ;
  pkgs = nixpkgsHost;
}

{
  inputs,
  patches ? _: { },
  hostSystem ? "x86_64-linux",
  username,
}:

let
  pkgsForPatching = import inputs.nixpkgs { system = hostSystem; };

  patchFetchers = rec {
    pr =
      repo: id: hash:
      pkgsForPatching.fetchurl {
        url = "https://github.com/${repo}/pull/${builtins.toString id}.diff?full_index=1";
        inherit hash;
      };
    npr = pr "NixOS/nixpkgs";
  };

  fetchedPatches = patches patchFetchers;

  patchInput =
    name: value:
    if (fetchedPatches.${name} or [ ]) != [ ] then
      let
        patchedSrc = pkgsForPatching.applyPatches {
          name = "source";
          src = value;
          patches = fetchedPatches.${name};
        };
      in
      # wasFlake = (value._type or "plain") == "flake";
      # if wasFlake
      # then builtins.getFlake patchedSrc
      # else patchedSrc
      patchedSrc
    else
      value;

  patchedInputs = builtins.mapAttrs patchInput inputs;

  overlays = import ../overlays.nix inputs;

  patchedNixpkgs = import patchedInputs.nixpkgs;

  patchedNixpkgsHost = patchedNixpkgs {
    system = hostSystem;
    inherit overlays;
    config.allowUnfree = true;
  };

  specialArgs = {
    inputs = patchedInputs;
    rawInputs = inputs;
    pkgsHost = patchedNixpkgsHost;
    inherit username;
  };

  mkSystem =
    {
      hostname,
      extraModules ? [ ],
      system ? "x86_64-linux",
      allowLocalDeployment ? false,
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
    {
      imports = [
        (
          { lib, ... }:
          {
            nixpkgs = {
              # inherit overlays;
              config = {
                allowUnfree = lib.mkForce true;
                allowAliases = lib.mkForce false;
              };

              hostPlatform = system;
            };

            deployment = {
              inherit allowLocalDeployment;
              targetHost = hostname;
            };

            networking.hostName = hostname;
          }
        )
      ]
      ++ deviceSpecificModules
      ++ extraModules;
    };

  mkWslSystem =
    { hostname }:
    mkSystem {
      hostname = "${hostname}-wsl";
      extraModules = [ ../common/wsl.nix ];
      allowLocalDeployment = true;
    };

  hiveMeta = {
    nixpkgs = patchedNixpkgsHost;
    inherit specialArgs;
  };

  mkHome =
    {
      username ? username,
      homeDirectory ? "/home/${username}",
      extraModules ? [ ],
      system ? "x86_64-linux",
    }:
    patchedInputs.home-manager.lib.homeManagerConfiguration {
      pkgs = patchedNixpkgs { inherit system overlays; };
      modules = [
        ../common/home-manager/standalone.nix
        {
          home = { inherit username homeDirectory; };
        }
      ]
      ++ extraModules;
      extraSpecialArgs = specialArgs;
    };
in
{
  inherit
    hiveMeta
    mkSystem
    mkWslSystem
    mkHome
    ;
  pkgs = patchedNixpkgsHost;
}

{
  description = "NixOS configuration";

  inputs = {
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
    nil = {
      url =  "github:oxalica/nil";
      inputs.nixpkgs.follows = "unstable";
    };
    helix.url = "github:helix-editor/helix";
  };

  outputs = { self, nixpkgs, nixgl, unstable, home-manager, ... }@inputs:
  {
    nixosConfigurations = {
      perdix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({config, ... }: { config.nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ]; })
          ./nixos/devices/perdix.nix
        ];
      };
    };

    homeConfigurations = {
      icarus = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home-manager/devices/icarus.nix ];
      };
      perdix = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home-manager/devices/perdix.nix ];
      };
    };
  };
}

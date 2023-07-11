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
  };

  outputs = { self, nixpkgs, nixgl, unstable, home-manager, ... }@inputs:
  {
    nixosConfigurations = {
      perdix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./nixos/devices/perdix.nix
          ({config, ... }: {
            config.nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];
          })


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

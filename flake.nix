{
  description = "NixOS configuration";

  inputs = {
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
    /* nixosConfigurations = {
      /* icarus.nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./nixos/devices/icarus.nix ];
      };
      perdix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./nixos/devices/perdix.nix ];
      };
    }; */

    homeConfigurations = {
      /* icarus = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./dotfiles/.config/home-manager/devices/icarus.nix ];
      }; */
      perdix = home-manager.lib.homeManagerConfiguration {
        # pkgs = nixpkgs.defaultPackages.x86_64-linux;
        pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
          };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./dotfiles/.config/home-manager/devices/perdix.nix ];
      };
    };
  };
}

{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      # url = "github:nix-community/home-manager/master";
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "unstable";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "unstable";
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs: {
    nixosConfigurations = {
      icarus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./nixos/devices/icarus.nix ];
      };
      perdix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./nixos/devices/perdix.nix ];
      };
    };

    homeConfigurations = let pkgs = nixpkgs.legacyPackages.x86_64-linux; in {
      icarus = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home-manager/devices/icarus.nix ];
      };
      perdix = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home-manager/devices/perdix.nix ];
      };
    };
  } //
  flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          inputs.nil.packages.x86_64-linux.nil
          nixpkgs-fmt
          lua-language-server
        ];
      };
    });
}

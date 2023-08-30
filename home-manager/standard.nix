{ config, pkgs, inputs, ... }:

{    
  nixpkgs = {
    overlays = [ 
      inputs.nur.overlay
      inputs.helix.overlays.default
      inputs.neovim-nightly.overlays.default
      inputs.nil.overlays.default
      # inputs.nixpkgs-wayland.overlay
      (self: super: { 
        unstable = import inputs.unstable {
          config = pkgs.config;
          system = pkgs.system;
        };
        xkeyboard-config = pkgs.unstable.xkeyboard-config;
        grawlix = pkgs.callPackage ./packages/grawlix.nix {};
        qt6Packages = pkgs.unstable.qt6Packages; # I don't know what needs this to build, but it isn't on stable branch...
      }) 
    ];
    config.allowUnfree = true;
  };
  services.syncthing.enable = true;

  nix = {
    package = pkgs.nix;
    # registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = "experimental-features = flakes nix-command";
  };

  # home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";

  imports = [
    # Programming
    ./terminal.nix
    ./programming.nix
    ./modules/brave.nix
    ./modules/firefox.nix
  ];
}

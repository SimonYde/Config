{ inputs, config, pkgs, ... }:

{    
  nixpkgs = {
    overlays = [ 
      # inputs.helix.overlay
      inputs.nur.overlay
      inputs.nixgl.overlay
      inputs.helix.overlays.default
      # inputs.nixpkgs-wayland.overlay
      (self: super: { 
        unstable = import inputs.unstable {
          config = pkgs.config;
          system = pkgs.system;
        };
        grawlix = pkgs.callPackage ./packages/grawlix.nix {};
        qt6Packages = pkgs.unstable.qt6Packages; # I don't know what needs this to build, but it isn't on stable branch...
      }) 
    ];
    config.allowUnfree = true;
  };
  services.syncthing.enable = true;

  nix = {
    package = pkgs.nix;
    extraOptions = "experimental-features = flakes nix-command";
  };

  imports = [
    # Programming
    ./terminal.nix
    ./programming.nix
    ./modules/brave.nix
    ./modules/firefox.nix
  ];
}

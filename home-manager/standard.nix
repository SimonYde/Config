{ inputs, config, pkgs, ... }:

{    
  nixpkgs = {
    overlays = [ 
      # inputs.helix.overlay
      inputs.nur.overlay
      inputs.nixgl.overlay
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


  /* home.file = {
    "${config.xdg.configHome}/audiobook-dl/audiobook-dl.toml".source = ../audiobook-dl/audiobook-dl.toml;
    "${config.xdg.configHome}/nvim/".source = ../nvim;
  }; */

  imports = [
    # Programming
    ./terminal.nix
    ./programming.nix
    ./modules/brave.nix
    ./modules/firefox.nix
  ];
}

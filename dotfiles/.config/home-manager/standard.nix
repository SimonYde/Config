{ config, pkgs, ... }:

{    
  nixpkgs = {
    overlays = [ 
      (self: super: { 
        unstable = import <unstable> {
          config = pkgs.config;
        };
        grawlix = pkgs.callPackage ./packages/grawlix.nix {};
      }) 
    ];
    config.packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    config.allowUnfree = true;
  };
  services.syncthing.enable = true;


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

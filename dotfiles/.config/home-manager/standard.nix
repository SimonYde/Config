{ config, pkgs, ... }:

{    
  nixpkgs = {
    overlays = [ 
      (self: super: { 
        unstable = import <unstable> {
          config = pkgs.config;
        };
        grawlix = pkgs.callPackage ./packages/grawlix.nix {};
        qt6Packages = pkgs.unstable.qt6Packages; # I don't know what needs this to build, but it isn't on stable branch...
        nixGL = pkgs.callPackage "${builtins.fetchTarball {
          url = "https://github.com/guibou/nixGL/archive/main.tar.gz";
          sha256 = "03kwsz8mf0p1v1clz42zx8cmy6hxka0cqfbfasimbj858lyd930k";
        }}/nixGL.nix" {};
      }) 
    ];
    config.packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    config.allowUnfree = true;
  };
  nix.extraOptions = ''
   experimental-features = flakes nix-command  
  '';
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

{ pkgs, ... }:

{
  programs = {
    brave.enable = true;
    firefox.enable = true;
    vscode.enable = true;
    zellij.enable = true;
  };

  home.packages = with pkgs; [
    unstable.obsidian
    nix
    synergy
    #gaming
    wine
    discord
    texlive.combined.scheme-full
  ];

  services.redshift = {
    enable = true;
    temperature = {
      day = 5500;
      night = 1800;
    };
    provider = "manual";
    latitude = 56.8;
    longitude = 9.0;
  };
  imports = [
    ../modules/gtk.nix
  ];
}

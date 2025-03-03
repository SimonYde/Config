{ lib, pkgs, ... }:

let
  inherit (lib) mkForce;
in
{

  home.packages = with pkgs; [
    # Applications
    (lutris.override {
      extraPkgs = pkgs: [
        pkgs.wineWowPackages.staging
        pkgs.wineWowPackages.fonts
        pkgs.winetricks
      ];
    })
    r2modman
    heroic
    bottles
    prismlauncher

    # ---Wine and Wine Dependencies---
    wineWowPackages.staging
    wineWowPackages.fonts
    winetricks
  ];

  programs.mangohud = {
    enable = true;
    settings = {
      background_alpha = mkForce 0.6;
      font_size = mkForce 13;
      font_scale = mkForce 1.0;
    };
    settingsPerApplication = {
      mpv = {
        no_display = true;
      };
    };
  };
}

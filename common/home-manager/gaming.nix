{ pkgs, lib, ... }:
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

    heroic
    prismlauncher

    # ---Wine and Wine Dependencies---
    wineWowPackages.staging
    wineWowPackages.fonts
    winetricks
  ];

  programs.mangohud = {
    enable = true;

    settings = {
      background_alpha = lib.mkForce 0.75;
      vram = true;
    };

    settingsPerApplication = {
      mpv.no_display = true;
    };
  };
}

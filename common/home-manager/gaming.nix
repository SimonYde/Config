{ pkgs, ... }:

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

    settingsPerApplication = {
      mpv = {
        no_display = true;
      };
    };
  };
}

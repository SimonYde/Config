{ pkgs, lib, ... }@args:
{
  home.packages = with pkgs; [
    # Applications
    heroic
    prismlauncher
    protontricks

    # ---Wine and Wine Dependencies---
    wineWow64Packages.staging
    wineWow64Packages.fonts
    winetricks
  ];

  programs.lutris = {
    enable = true;

    extraPackages = with pkgs; [
      mangohud
      winetricks
      protontricks
      gamescope
      gamemode
      umu-launcher
    ];

    protonPackages = [ pkgs.proton-ge-bin ];

    steamPackage = if (args ? osConfig) then args.osConfig.programs.steam.package else pkgs.steam;

    winePackages = with pkgs; [
      wineWow64Packages.fonts
      wineWow64Packages.staging
    ];
  };

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

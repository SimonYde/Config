{ pkgs, lib, ... }@args:
{
  home.packages = with pkgs; [
    # Applications
    heroic # Epic / Gog
    # limo # mod manager
    # nexusmods-app-unfree # WIP official Nexusmods mod manager

    # ---Wine and Wine Dependencies---
    wineWow64Packages.staging
    wineWow64Packages.fonts
    winetricks
    protontricks
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

  # Minecraft
  programs.prismlauncher = {
    enable = true;
  };

  programs.mangohud = {
    enable = true;

    settings = {
      fps_limit = 160;
      background_alpha = lib.mkForce 0.75;
      vram = true;
      ram = true;
      cpu_temp = true;
      gpu_temp = true;
    };
  };
}

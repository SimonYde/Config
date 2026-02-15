{ pkgs, lib, ... }@args:
{
  home.packages = with pkgs; [
    # Applications
    heroic # Epic / Gog
    # limo # mod manager
    # nexusmods-app-unfree # WIP official Nexusmods mod manager

    winetricks
    protontricks
  ];

  programs = {
    lutris = {
      enable = true;

      extraPackages = with pkgs; [
        mangohud
        winetricks
        protontricks
        gamescope
        gamemode
        umu-launcher
      ];

      defaultWinePackage = pkgs.proton-ge-bin;
      protonPackages = [ pkgs.proton-ge-bin ];

      steamPackage = if (args ? osConfig) then args.osConfig.programs.steam.package else pkgs.steam;

      winePackages = with pkgs; [
        wineWow64Packages.fonts
        wineWow64Packages.waylandFull
      ];
    };

    mangohud = {
      enable = true;

      settings = {
        time = true;
        fps_limit = 160;
        winesync = true;
        background_alpha = lib.mkForce 0.75;
        vram = true;
        ram = true;
        cpu_temp = true;
        gpu_temp = true;
      };
    };

    prismlauncher = {
      enable = true;
    };
  };
}

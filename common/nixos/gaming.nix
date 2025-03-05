{
  pkgs,
  lib,
  username,
  ...
}:
let
  inherit (lib) mkForce;
in
{
  home-manager.users.${username}.imports = [ ../home-manager/gaming.nix ];

  powerManagement.cpuFreqGovernor = mkForce "performance";

  programs = {
    gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          renice = 10;
        };

        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started' && hyprland-gamemode";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended' && hyprland-gamemode";
        };
      };
    };

    steam = {
      enable = true;
      gamescopeSession.enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin # glorious eggroll
      ];

      fontPackages = with pkgs; [
        wineWowPackages.fonts
        source-han-sans
      ];
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      vulkan-tools
      vulkan-loader
      mesa
      libva
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-tools
      vulkan-loader
      mesa
      libva
    ];
  };
}

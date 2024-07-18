{ pkgs, ... }:

{
  programs.gamemode = {
    settings = {
      general = {
        renice = 10;
      };

      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started' && hyprland-gamemode";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended' && hyprland-gamemode";
      };
    };
    enableRenice = true;
  };
}

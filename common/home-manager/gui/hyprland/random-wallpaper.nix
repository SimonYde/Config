{
  pkgs,
  config,
  lib,
  ...
}:
let
  hyprland = config.wayland.windowManager.hyprland.package;

  random-wallpaper = pkgs.writeShellScriptBin "random-wallpaper" ''
    CURRENT=$(${hyprland}/bin/hyprctl hyprpaper listloaded)
    WALLPAPER_DIR=${config.xdg.userDirs.pictures}/wallpapers/${config.lib.stylix.colors.slug}

    # Get a random wallpaper that is not the current one
    WALLPAPER=$(${pkgs.fd}/bin/fd . "$WALLPAPER_DIR" -t f -E "$CURRENT" | shuf -n 1)

    # Apply the selected wallpaper
    ${hyprland}/bin/hyprctl hyprpaper reload ,"$WALLPAPER"
  '';
in
{
  home.packages = [ random-wallpaper ];

  systemd.user.services.random-wallpaper = {
    Unit = {
      Description = "Cycle hyprpaper to new wallpaper at random.";
      After = [
        "graphical-session-pre.target"
        "hyprpaper.service"
      ];
      PartOf = [ config.wayland.systemd.target ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe random-wallpaper;
      IOSchedulingClass = "idle";
    };

    Install.WantedBy = [ config.wayland.systemd.target ];
  };

  systemd.user.timers.random-wallpaper = {
    Unit.Description = "Cycle hyprpaper to new wallpaper at random.";

    Timer.OnUnitActiveSec = "15min";

    Install.WantedBy = [ "timers.target" ];
  };
}

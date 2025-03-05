{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) getExe mkIf;
  cfg = config.services.hyprpaper;
  random-wallpaper = pkgs.writeShellScriptBin "random-wallpaper" ''
    CURRENT=$(${pkgs.hyprland}/bin/hyprctl hyprpaper listloaded)
    WALLPAPER_DIR=${config.xdg.userDirs.pictures}/wallpapers/${config.lib.stylix.colors.slug}

    # Get a random wallpaper that is not the current one
    WALLPAPER=$(${getExe pkgs.fd} . "$WALLPAPER_DIR" -t f -E "$CURRENT" | shuf -n 1)

    # Apply the selected wallpaper
    ${pkgs.hyprland}/bin/hyprctl hyprpaper reload ,"$WALLPAPER"
  '';
in
{
  config = mkIf cfg.enable {
    home.packages = [ random-wallpaper ];

    systemd.user.services.random-wallpaper = {
      Unit = {
        Description = "Cycle hyprpaper to new wallpaper at random.";
      };
      Service = {
        Type = "oneshot";
        ExecStart = getExe random-wallpaper;
      };
    };

    systemd.user.timers.random-wallpaper = {
      Unit = {
        Description = "Cycle hyprpaper to new wallpaper at random.";
        PartOf = [ config.wayland.systemd.target ];
        After = [ "hyprpaper.service" ];
      };
      Timer = {
        OnStartupSec = "5sec";
        OnUnitActiveSec = "15min";
        Unit = "random-wallpaper.service";
      };
      Install = {
        WantedBy = [ "hyprpaper.service" ];
      };
    };
  };
}

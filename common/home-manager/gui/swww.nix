{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    getExe
    mkOption
    types
    ;

  cfg = config.services.swww;

  random-wallpaper =
    pkgs.writers.writeNuBin "random-wallpaper" # nu
      ''
        const WALLPAPER_DIR = "${cfg.wallpaperDir}"
        let current = swww query | parse --regex "image: (?<image>.*$)" | default --empty [{ image: "" }] | first | get image

        cd $WALLPAPER_DIR
        let new = glob **/*.{png,jpeg,jpg} | where $it != $current | shuffle | first
        swww img $new

        if "XDG_RUNTIME_DIR" in $env {
          ln --symbolic --force $"($new)" $"($env.XDG_RUNTIME_DIR)/current-wallpaper"
        }
      '';
in
{
  options.services.swww = {
    wallpaperDir = mkOption {
      type = types.str;
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ random-wallpaper ];

    systemd.user = {
      timers.random-wallpaper = {

        Unit.Description = "Cycle hyprpaper to new wallpaper at random";

        Timer.OnUnitActiveSec = "15min";

        Install.WantedBy = [ "timers.target" ];
      };

      services.random-wallpaper = {
        Unit = {
          Description = "Cycle hyprpaper to new wallpaper at random";
          After = [ "swww.service" ];
          Requires = [ "swww.service" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = getExe random-wallpaper;
          IOSchedulingClass = "idle";
          Restart = "on-failure";
          RestartSec = "10";
        };

        Install.WantedBy = [ "swww.service" ];
      };
    };
  };
}

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

  cfg = config.services.awww;

  random-wallpaper =
    pkgs.writers.writeNuBin "random-wallpaper" # nu
      ''
        const WALLPAPER_DIR = "${cfg.wallpaperDir}"

        let current = awww query | parse --regex "image: (?<image>.*$)" | default --empty [{ image: "" }] | first | get image

        cd $WALLPAPER_DIR

        let new = glob **/*.{png,jpeg,jpg} | where $it != $current | shuffle | first

        awww img $new

        if "XDG_RUNTIME_DIR" in $env {
          ln --symbolic --force $"($new)" $"($env.XDG_RUNTIME_DIR)/current-wallpaper"
        }
      '';
in
{
  options.services.awww = {
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
          After = [ "awww.service" ];
          Requires = [ "awww.service" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = getExe random-wallpaper;
          IOSchedulingClass = "idle";
          Restart = "on-failure";
          RestartSec = "10";
        };

        Install.WantedBy = [ "awww.service" ];
      };
    };
  };
}

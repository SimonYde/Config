{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;

  cfg = config.services.swww;

  random-wallpaper =
    pkgs.writers.writeNuBin "random-wallpaper" # nu
      ''
        const WALLPAPER_DIR = "${config.home.sessionVariables.WALLPAPER_DIR}"

        let current = swww query | lines | parse --regex "image: (.*$)" | first | get capture0
        cd $WALLPAPER_DIR
        let new = glob **/*.{png,jpeg,jpg} | where $it != $current | shuffle | first
        swww img $new
      '';
in
{
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

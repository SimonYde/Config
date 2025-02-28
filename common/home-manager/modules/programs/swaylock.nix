{
  config,
  pkgs,
  lib,
  ...
}:
let
  font = config.stylix.fonts.sansSerif;
  cfg = config.programs.swaylock;
in
{
  config = lib.mkIf cfg.enable {
    programs.swaylock = {
      package = pkgs.swaylock-effects;
      settings = {
        daemonize = true;
        screenshot = true;
        show-failed-attempts = true;
        ignore-empty-password = true;

        font = font.name;
        font-size = 45;

        clock = true;
        datestr = "%A, %b %e";
        timestr = "%H:%M";

        indicator = true;
        indicator-radius = 200;
        indicator-thickness = 10;

        grace = 0;
        grace-no-mouse = true;
        grace-no-touch = true;
        fade-in = 0.5;
      };
    };
    services.hypridle.settings.general.lock_cmd = "swaylock";
  };
}

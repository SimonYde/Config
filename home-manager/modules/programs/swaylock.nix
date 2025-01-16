{
  config,
  pkgs,
  lib,
  ...
}:
let
  palette = config.colorScheme.palette;
  font = config.syde.theming.fonts.sansSerif;
  cfg = config.programs.swaylock;
in
{
  config = lib.mkIf cfg.enable {
    programs.swaylock = {
      package = pkgs.swaylock-effects;
      settings = with palette; {
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

        color = "${base00}00";

        bs-hl-color = "${base08}";
        inside-clear-color = "${base00}00";
        inside-color = "${base00}00";
        inside-ver-color = "${base00}00";
        inside-wrong-color = "${base00}00";
        key-hl-color = "${base0B}";
        line-color = "${base0D}00";
        ring-color = "${base0D}00";
        separator-color = "00000000";
        line-clear-color = "${base0B}";
        ring-clear-color = "${base0B}";
        line-ver-color = "${base0C}";
        ring-ver-color = "${base0C}";
        line-wrong-color = "${base08}";
        ring-wrong-color = "${base08}";

        text-caps-lock-color = base08;
        text-clear-color = base05;
        text-color = base05;
        text-ver-color = base05;
        text-wrong-color = base05;

        effect-blur = "7x5";
        effect-vignette = "1:1";

        grace = 0;
        grace-no-mouse = true;
        grace-no-touch = true;
        fade-in = 0.5;
      };
    };
    syde.gui.lock = "${pkgs.swaylock-effects}/bin/swaylock";
  };
}

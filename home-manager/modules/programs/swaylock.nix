{
  config,
  pkgs,
  lib,
  ...
}:
let
  colors = config.colorScheme.palette;
  fontName = config.syde.theming.fonts.sansSerif.name;
  cfg = config.programs.swaylock;
in
{
  config = lib.mkIf cfg.enable {
    programs.swaylock = {
      package = pkgs.swaylock-effects;
      settings = with colors; {
        daemonize = true;
        screenshot = true;
        show-failed-attempts = true;
        ignore-empty-password = true;

        font = fontName;
        font-size = 24;

        clock = true;
        datestr = "%A, %b %e";
        timestr = "%H:%M";

        indicator = true;
        indicator-radius = 200;
        indicator-thickness = 20;

        color = "${base00}33";

        bs-hl-color = base08;
        inside-clear-color = "${base00}33";
        inside-color = "${base00}33";
        inside-ver-color = "${base00}33";
        inside-wrong-color = "${base00}33";
        key-hl-color = base0B;
        line-color = base0D;
        ring-color = base0D;
        separator-color = "00000000";
        line-clear-color = base0B;
        ring-clear-color = base0B;
        line-ver-color = base0C;
        ring-ver-color = base0C;
        line-wrong-color = base08;
        ring-wrong-color = base08;

        text-caps-lock-color = base08;
        text-clear-color = base05;
        text-color = base05;
        text-ver-color = base05;
        text-wrong-color = base05;

        effect-blur = "7x5";
        effect-vignette = "1:1";

        grace = 1.5;
        grace-no-mouse = true;
        grace-no-touch = true;
        fade-in = 0.5;
      };
    };
    home.shellAliases = {
      lock = "swaylock -f";
    };
  };
}

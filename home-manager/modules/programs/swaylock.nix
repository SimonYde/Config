{ config, pkgs, ... }:
let
  colors = config.colorScheme.palette;
  font = config.syde.terminal.font;
in
{
  programs.swaylock = {
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      screenshot = true;
      show-failed-attempts = true;
      ignore-empty-password = true;

      font = "${font}";
      font-size = 24;

      clock = true;
      datestr = "%A, %b %e";
      timestr = "%H:%M";

      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 20;

      color = "${colors.base00}";

      bs-hl-color = "${colors.base08}";
      inside-clear-color = "${colors.base00}";
      inside-color = "${colors.base00}";
      inside-ver-color = "${colors.base00}";
      inside-wrong-color = "${colors.base00}";
      key-hl-color = "${colors.base07}";
      line-clear-color = "${colors.base07}";
      line-color = "${colors.base0E}";
      line-ver-color = "${colors.base0D}";
      line-wrong-color = "${colors.base00}";
      ring-clear-color = "${colors.base07}";
      ring-color = "${colors.base0E}";
      ring-ver-color = "${colors.base0D}";
      ring-wrong-color = "${colors.base08}";
      separator-color = "${colors.base07}";

      text-caps-lock-color = "${colors.base08}";
      text-clear-color = "${colors.base05}";
      text-color = "${colors.base05}";
      text-ver-color = "${colors.base05}";
      text-wrong-color = "${colors.base05}";

      effect-blur = "7x5";
      effect-vignette = "1:1";

      grace = 2;
      grace-no-mouse = true;
      grace-no-touch = true;
      fade-in = 0.3;
    };
  };
}

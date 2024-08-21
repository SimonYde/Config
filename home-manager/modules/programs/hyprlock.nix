{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.hyprlock;
in

{
  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      settings = with config.syde.theming.palette-hex; {
        general = {
          disable_loading_bar = true;
          ignore_empty_input = true;
          grace = 10;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        input-field = [
          {
            size = "200, 50";
            outline_thickness = 3;
            dots_center = true;
            fade_on_empty = true;
            font_color = base05;
            inner_color = base02;
            monitor = "";
            outer_color = base00;
            placeholder_text = "<i>Password...</i>";
            position = "0, -80";

            shadow_passes = 2;
          }
        ];
      };
    };
    syde.gui.lock = lib.getExe pkgs.hyprlock;
  };
}

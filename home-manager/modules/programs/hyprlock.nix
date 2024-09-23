{
  config,
  lib,
  ...
}:

let
  palette = config.syde.theming.palette-rgb;
  cfg = config.programs.hyprlock;
in

{
  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      settings = with palette; {
        general = {
          disable_loading_bar = true;
          ignore_empty_input = true;
          grace = 2;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        input-field = [
          {
            monitor = "";
            size = "200, 50";
            outline_thickness = 2;
            dots_center = true;
            fade_on_empty = true;
            font_color = "rgba(${base05},1.0)";
            inner_color = "rgba(${base02},0.85)";
            outer_color = "rgba(${base0D},0.85)";
            check_color = "rgba(${base0A},0.85)";
            fail_color = "rgba(${base08},0.85)";
            placeholder_text = "<i>Password...</i>";
            position = "0, -80";

            shadow_passes = 2;
          }
        ];
        label = [
          {
            monitor = "";
            text = ''cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"'';
            text_align = "center";
            color = "rgba(${base05},1.0)";
            font_size = 45;
            font_family = config.syde.theming.fonts.sansSerif.name;
            rotate = 0;
            position = "0, 80";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
        ];
      };
    };
    syde.gui.lock = "pidof hyprlock || hyprlock";
  };
}

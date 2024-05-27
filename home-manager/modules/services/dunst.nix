{ config, lib, ... }:
let
  terminal = config.syde.terminal;
  colors = config.colorScheme.palette;
in
{
  services.dunst = {
    settings = with colors; lib.mkDefault {
      global = {
        frame_color = "#${base0D}";
        font = "${terminal.font} 10";
        frame_width = 2;
        separator_color = "frame";
        corner_radius = 10;
        icon_position = "left";
        show_indicator = true;
      };

      urgency_low = {
        background = "#${base00}";
        foreground = "#${base05}";
      };

      urgency_normal = {
        background = "#${base00}";
        foreground = "#${base05}";
      };

      urgency_critical = {
        background = "#${base00}";
        foreground = "#${base05}";
        frame_color = "#${base08}";
      };
    };
  };
}

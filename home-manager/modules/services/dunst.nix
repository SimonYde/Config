{ config, lib, ... }:
let
  inherit (lib) mkDefault mkForce;
  font = config.syde.theming.fonts.sansSerif;
in
{
  services.dunst = {
    settings = with config.syde.theming.palette-hex; {
      global = {
        frame_color = "#${base0D}";
        font = mkDefault "${font.name} 10";
        frame_width = 2;
        # separator_color = "frame";
        corner_radius = mkForce 10;
        icon_position = "left";
        show_indicator = true;
      };

      urgency_low = mkDefault {
        background = "#${base00}";
        foreground = "#${base05}";
      };

      urgency_normal = mkDefault {
        background = "#${base00}";
        foreground = "#${base05}";
      };

      urgency_critical = mkDefault {
        background = "#${base00}";
        foreground = "#${base05}";
        frame_color = "#${base08}";
      };
    };
  };
}

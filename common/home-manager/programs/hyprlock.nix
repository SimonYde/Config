{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf mkForce;
  inherit (config.lib.stylix) colors;
  cfg = config.programs.hyprlock;
in

{
  config = mkIf cfg.enable {
    programs.hyprlock = {
      settings = {
        general = {
          disable_loading_bar = false;
          ignore_empty_input = true;
          grace = 2;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = mkForce {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        };
        input-field = {
          monitor = "";
          size = "200, 50";
          outline_thickness = 2;
          dots_center = true;
          fade_on_empty = true;
          placeholder_text = "<i>Password...</i>";
          position = "0, -80";
          shadow_passes = 2;
        };
        label = {
          monitor = "";
          text = ''cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"'';
          text_align = "center";
          color = "rgb(${colors.base05})";
          font_size = 45;
          font_family = config.stylix.fonts.sansSerif.name;
          rotate = 0;
          position = "0, 80";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
        };
      };
    };
    services.hypridle.settings.general.lock_cmd = "pidof hyprlock || hyprlock";
  };
}

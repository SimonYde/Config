{
  lib,
  config,
  ...
}:

let
  inherit (lib)
    mkIf
    mkForce
    ;
  cfg = config.programs.ghostty;
in
{
  config = mkIf cfg.enable {
    programs.ghostty = {
      settings = {
        font-size = mkForce config.syde.terminal.fontSize;
        gtk-titlebar = false;
        gtk-adwaita = true;
        gtk-single-instance = true;
        unfocused-split-opacity = 0.95;
        window-decoration = false;
        keybind = [
          "ctrl+alt+tab=toggle_tab_overview"
        ];
      };
    };
  };
}

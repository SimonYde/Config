{
  lib,
  config,
  ...
}:

let
  inherit (lib)
    mkIf
    mkForce
    getAttr
    ;
  cfg = config.programs.ghostty;
  theme_name =
    theme:
    getAttr theme {
      "catppuccin-mocha" = "catppuccin-mocha";
      "gruvbox-dark-hard" = "GruvboxDarkHard";
    };
  theme = theme_name config.colorScheme.slug;
in
{
  config = mkIf cfg.enable {
    programs.ghostty = {
      settings = {
        theme = mkForce theme;
        font-size = mkForce config.syde.terminal.fontSize;
        gtk-titlebar = false;
        gtk-adwaita = true;
        window-decoration = false;
        keybind = [
          "ctrl+alt+tab=toggle_tab_overview"
        ];
      };
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  theming = config.syde.theming;
  prefer-dark = theming.prefer-dark;
  cfg = config.gtk;
in
{
  config = lib.mkIf cfg.enable {
    gtk = {
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      };
      iconTheme = {
        name = if prefer-dark then "Papirus-Dark" else "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = if prefer-dark then theming.gtk.darkTheme else theming.gtk.lightTheme;
        package = theming.gtk.package;
      };
      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = prefer-dark;
        };
      };
      gtk4 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = prefer-dark;
        };
      };
    };

    home.sessionVariables = {
      GTK_THEME = cfg.theme.name;
    };
  };
}

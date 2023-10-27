{ config, pkgs, lib, ... }:
let
  themes = config.themes;
  flavour = themes.flavour;
  prefer-dark = themes.prefer-dark;
  cfg = config.gtk;
in
{
  config = lib.mkIf cfg.enable {
    gtk = {
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
        # package = pkgs.papirus-icon-theme.override {
        #   papirus-folders = pkgs.catppuccin-papirus-folders.override {
        #     accent = "lavender";
        #     flavor = flavour;
        #   };
        # };
      };
      theme = {
        name =
          if prefer-dark then "Catppuccin-Mocha-Compact-Lavender-Dark"
          else "Catppuccin-Latte-Compact-Lavender-Light";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "lavender" ];
          size = "compact";
          tweaks = [ "rimless" ];
          variant = flavour;
        };
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

{ config, pkgs, lib, ... }:
let
  flavour = config.themes.flavour;
in
{
  gtk = {
    enable = true;
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
      name = if flavour == "mocha" then "Catppuccin-Mocha-Compact-Lavender-Dark" else "Catppuccin-Latte-Compact-Lavender-Light";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        size = "compact";
        tweaks = [ "rimless" ];
        variant = flavour;
      };
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = flavour == "mocha";
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = flavour == "mocha";
      };
    };
  };

  home.sessionVariables = lib.mkIf config.gtk.enable {
    GTK_THEME = config.gtk.theme.name;
  };
}

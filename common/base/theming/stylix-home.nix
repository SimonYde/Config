{ pkgs, config, ... }:
let
  inherit (config.lib.stylix) colors;
in
{
  stylix = {
    iconTheme = {
      enable = true;
      dark = "Papirus-Dark";
      light = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    targets = {
      hyprpaper.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      swaylock.useImage = false;
      vim.enable = false;
      helix.enable = true;
      neovim.enable = false;
      nushell.enable = false;
      waybar.enable = false;
      zellij.enable = false;
      zathura.enable = true;
      fzf.enable = true;
    };
  };

  home.packages = with pkgs; [
    font-awesome
    gentium
    atkinson-hyperlegible
    atkinson-monolegible
    libertinus
    newcomputermodern
    roboto
    source-sans-pro
  ];

  gtk = {
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = colors.variant == "dark";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = colors.variant == "dark";
    };
  };

  home.sessionVariables.GTK_THEME = config.gtk.theme.name;

  programs.git.difftastic.background = colors.variant;
}

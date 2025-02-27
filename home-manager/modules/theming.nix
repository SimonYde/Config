{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  prefer-dark = config.lib.stylix.colors.variant == "dark";
  cfg = config.stylix;
in
{
  imports = [ inputs.stylix.homeManagerModules.stylix ];

  config = mkIf config.syde.theming.enable {
    stylix = {
      enable = true;
      image = config.lib.stylix.pixel "base00";
      base16Scheme = "${inputs.tinted-schemes}/base16/gruvbox-dark-hard.yaml";
      override = {
        base00 = "1b1b1b";
      };
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
      cursor = {
        name = "volantes_cursors";
        package = pkgs.volantes-cursors;
        size = 24;
      };
      fonts = {
        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        sansSerif = {
          name = "JetBrainsMono Nerd Font Propo";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        serif = {
          name = "Gentium Plus";
          package = pkgs.gentium;
        };
        emoji = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-emoji;
        };
        sizes = {
          terminal = 11.5;
          popups = 13;
        };
      };

      opacity = {
        terminal = 0.85;
        popups = 0.80;
      };
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ cfg.fonts.monospace.name ];
        serif = [ cfg.fonts.serif.name ];
        sansSerif = [ cfg.fonts.sansSerif.name ];
        emoji = [ cfg.fonts.emoji.name ];
      };
    };
    # additional fonts
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

    gtk.enable = true;
    gtk = {
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = prefer-dark;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = prefer-dark;
      };
    };

    home.sessionVariables.GTK_THEME = config.gtk.theme.name;
  };

  options.syde.theming = {
    enable = mkEnableOption "Personal rice";
  };
}

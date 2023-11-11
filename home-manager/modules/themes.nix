{ inputs, lib, config, pkgs, ... }:
let
  mkColor = hex: lib.mkOption {
    type    = lib.types.str;
    default = "${hex}";
  };
  nix-colors = inputs.nix-colors;
  cfg = config.themes;
in
{
  imports = [
    nix-colors.homeManagerModules.default
  ];

  config.colorScheme = nix-colors.colorSchemes."catppuccin-${cfg.flavour}";

  options.themes = {
    flavour = lib.mkOption {
      type    = lib.types.str;
      default = if config.themes.prefer-dark then "mocha" else "latte";
    };
    prefer-dark = lib.mkOption {
      type    = lib.types.bool;
      default = true;
    };
    catppuccin = {
      mocha = {
        base      = mkColor "#1e1e2e";
        mantle    = mkColor "#181825";
        surface0  = mkColor "#313244";
        surface1  = mkColor "#45475a";
        surface2  = mkColor "#585b70";
        text      = mkColor "#cdd6f4";
        rosewater = mkColor "#f5e0dc";
        lavender  = mkColor "#b4befe";
        red       = mkColor "#f38ba8";
        peach     = mkColor "#fab387";
        yellow    = mkColor "#f9e2af";
        green     = mkColor "#a6e3a1";
        teal      = mkColor "#94e2d5";
        blue      = mkColor "#89b4fa";
        mauve     = mkColor "#cba6f7";
        flamingo  = mkColor "#f2cdcd";
      };
      latte = {
        base      = mkColor "#eff1f5";
        mantle    = mkColor "#e6e9ef";
        surface0  = mkColor "#ccd0da";
        surface1  = mkColor "#bcc0cc";
        surface2  = mkColor "#acb0be";
        text      = mkColor "#4c4f69";
        rosewater = mkColor "#dc8a78";
        lavender  = mkColor "#7287fd";
        red       = mkColor "#d20f39";
        peach     = mkColor "#fe640b";
        yellow    = mkColor "#df8e1d";
        green     = mkColor "#40a02b";
        teal      = mkColor "#179299";
        blue      = mkColor "#1e66f5";
        mauve     = mkColor "#8839ef";
        flamingo  = mkColor "#dd7878";
      };
    };
    gtk = {
      darkTheme = lib.mkOption {
        type    = lib.types.str;
        default = "Catppuccin-Mocha-Compact-Lavender-Dark";
      };
      lightTheme = lib.mkOption {
        type    = lib.types.str;
        default = "Catppuccin-Latte-Compact-Lavender-Light";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.catppuccin-gtk.override {
          accents = [ "lavender" ];
          size    = "compact";
          tweaks  = [ "rimless" ];
          variant = cfg.flavour;
        };
      };
    };
    cursorTheme = {
      name = lib.mkOption {
        type    = lib.types.str;
        default = "Catppuccin-Mocha-Dark-Cursors";
      };
      package = lib.mkOption {
        type    = lib.types.package;
        default = pkgs.catppuccin-cursors.mochaDark;
      };
    };
  };
}

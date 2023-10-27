{ lib, config, ... }:
let
  mkColor = hex: lib.mkOption {
    type = lib.types.str;
    default = "${hex}";
  };
in
{
  options.themes = {
    flavour = lib.mkOption {
      type = lib.types.str;
      default = if config.themes.prefer-dark then "mocha" else "latte";
    };
    prefer-dark = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    catppuccin = {
      mocha = {
        base = mkColor "#1e1e2e";
        mantle = mkColor "#181825";
        surface0 = mkColor "#313244";
        surface1 = mkColor "#45475a";
        surface2 = mkColor "#585b70";
        text = mkColor "#cdd6f4";
        rosewater = mkColor "#f5e0dc";
        lavender = mkColor "#b4befe";
        red = mkColor "#f38ba8";
        peach = mkColor "#fab387";
        yellow = mkColor "#f9e2af";
        green = mkColor "#a6e3a1";
        teal = mkColor "#94e2d5";
        blue = mkColor "#89b4fa";
        mauve = mkColor "#cba6f7";
        flamingo = mkColor "#f2cdcd";
      };
      latte = {
        base = mkColor "#eff1f5";
        mantle = mkColor "#e6e9ef";
        surface0 = mkColor "#ccd0da";
        surface1 = mkColor "#bcc0cc";
        surface2 = mkColor "#acb0be";
        text = mkColor "#4c4f69";
        rosewater = mkColor "#dc8a78";
        lavender = mkColor "#7287fd";
        red = mkColor "#d20f39";
        peach = mkColor "#fe640b";
        yellow = mkColor "#df8e1d";
        green = mkColor "#40a02b";
        teal = mkColor "#179299";
        blue = mkColor "#1e66f5";
        mauve = mkColor "#8839ef";
        flamingo = mkColor "#dd7878";
      };
    };
  };

}

{ lib, config, ... }:

{
  # catppuccin = {
  #   mocha = {
  #     base = "#1e1e2e";
  #     mantle = "#181825";
  #     surface0 = "#313244";
  #     surface1 = "#45475a";
  #     surface2 = "#585b70";
  #     text = "#cdd6f4";
  #     rosewater = "#f5e0dc";
  #     lavender = "#b4befe";
  #     red = "#f38ba8";
  #     peach = "#fab387";
  #     yellow = "#f9e2af";
  #     green = "#a6e3a1";
  #     teal = "#94e2d5";
  #     blue = "#89b4fa";
  #     mauve = "#cba6f7";
  #     flamingo = "#f2cdcd";
  #   };
  #   latte = {
  #     base = "#eff1f5";
  #     mantle = "#e6e9ef";
  #     surface0 = "#ccd0da";
  #     surface1 = "#bcc0cc";
  #     surface2 = "#acb0be";
  #     text = "#4c4f69";
  #     rosewater = "#dc8a78";
  #     lavender = "#7287fd";
  #     red = "#d20f39";
  #     peach = "#fe640b";
  #     yellow = "#df8e1d";
  #     green = "#40a02b";
  #     teal = "#179299";
  #     blue = "#1e66f5";
  #     mauve = "#8839ef";
  #     flamingo = "#dd7878";
  #   };
  # };


  options.themes.flavour = lib.mkOption {
    type = lib.types.str;
    default = "mocha";
  };
}

{ lib, ... }:

{
  options.themes = with lib; {
    flavour = mkOption {
      type = types.str;
      default = "mocha";
    };
    prefer-dark = mkOption {
      type = types.bool;
      default = true;
    };
    catppuccin = {
      mocha = {
        base = mkOption {
          type = types.str;
          default = "#1e1e2e";
        };
        mantle = mkOption {
          type = types.str;
          default = "#181825";
        };
        surface0 = mkOption {
          type = types.str;
          default = "#313244";
        };
        surface1 = mkOption {
          type = types.str;
          default = "#45475a";
        };
        surface2 = mkOption {
          type = types.str;
          default = "#585b70";
        };
        text = mkOption {
          type = types.str;
          default = "#cdd6f4";
        };
        rosewater = mkOption {
          type = types.str;
          default = "#f5e0dc";
        };
        lavender = mkOption {
          type = types.str;
          default = "#b4befe";
        };
        red = mkOption {
          type = types.str;
          default = "#f38ba8";
        };
        peach = mkOption {
          type = types.str;
          default = "#fab387";
        };
        yellow = mkOption {
          type = types.str;
          default = "#f9e2af";
        };
        green = mkOption {
          type = types.str;
          default = "#a6e3a1";
        };
        teal = mkOption {
          type = types.str;
          default = "#94e2d5";
        };
        blue = mkOption {
          type = types.str;
          default = "#89b4fa";
        };
        mauve = mkOption {
          type = types.str;
          default = "#cba6f7";
        };
        flamingo = mkOption {
          type = types.str;
          default = "#f2cdcd";
        };
      };

      latte = {
        base = mkOption {
          type = types.str;
          default = "#eff1f5";
        };
        mantle = mkOption {
          type = types.str;
          default = "#e6e9ef";
        };
        surface0 = mkOption {
          type = types.str;
          default = "#ccd0da";
        };
        surface1 = mkOption {
          type = types.str;
          default = "#bcc0cc";
        };
        surface2 = mkOption {
          type = types.str;
          default = "#acb0be";
        };
        text = mkOption {
          type = types.str;
          default = "#4c4f69";
        };
        rosewater = mkOption {
          type = types.str;
          default = "#dc8a78";
        };
        lavender = mkOption {
          type = types.str;
          default = "#7287fd";
        };
        red = mkOption {
          type = types.str;
          default = "#d20f39";
        };
        peach = mkOption {
          type = types.str;
          default = "#fe640b";
        };
        yellow = mkOption {
          type = types.str;
          default = "#df8e1d";
        };
        green = mkOption {
          type = types.str;
          default = "#40a02b";
        };
        teal = mkOption {
          type = types.str;
          default = "#179299";
        };
        blue = mkOption {
          type = types.str;
          default = "#1e66f5";
        };
        mauve = mkOption {
          type = types.str;
          default = "#8839ef";
        };
        flamingo = mkOption {
          type = types.str;
          default = "#dd7878";
        };
      };
    };
  };

}

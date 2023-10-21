{ config, ... }:
let
  flavour = config.themes.flavour;
  catppuccin = config.themes.catppuccin;
in
{
  programs.zellij = {
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;

    settings = {
      theme = "catppuccin";
      themes.catppuccin = with catppuccin.${flavour}; {
        bg = surface2;
        fg = text;
        red = red;
        green = green;
        blue = blue;
        yellow = yellow;
        magenta = mauve;
        orange = peach;
        cyan = teal;
        black = mantle;
        white = text;
      };
      default_layout = "compact";
      default_shell = "fish";
      # on_force_close = "quit";
      simplified_ui = false;
      pane_frames = false;
      # copy_command = "xclip -selection clipboard";
    };
  };
}

{ config, pkgs, ... }:

let terminal = config.syde.terminal; in
{
  programs.kitty = {
    theme = if config.themes.flavour == "mocha" then "Catppuccin-Mocha" else "Catppuccin-Latte";
    font = {
      name = terminal.font;
      size = terminal.fontSize;
      # package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    };
    settings = {
      bold_font = terminal.font + " Regular";
      italic_font = terminal.font + " Italic";
      bold_italic_font = terminal.font + " Bold Italic";
      cursor_shape = "beam";
      cursor_blink_interval = 0;
    };
  };

}

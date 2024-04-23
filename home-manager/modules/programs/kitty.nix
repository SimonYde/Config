{
  config,
  pkgs,
  lib,
  ...
}: let
  terminal = config.syde.terminal;
in {
  programs.kitty = {
    theme =
      if config.syde.theming.prefer-dark
      then "Catppuccin-Mocha"
      else "Catppuccin-Latte";
    font = {
      name = terminal.font;
      size = terminal.fontSize;
    };
    settings = {
      # bold_font = terminal.font + " Regular";
      # italic_font = terminal.font + " Italic";
      # bold_italic_font = terminal.font + " Bold Italic";
      cursor_shape = terminal.cursor;
      cursor_blink_interval = 0;

      background_opacity = lib.strings.floatToString terminal.opacity;
    };
  };
}

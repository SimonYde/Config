{ config, lib, ... }:
let
  terminal = config.syde.terminal;
  font = config.syde.theming.fonts.monospace;
in
{
  programs.kitty = {
    font = lib.mkForce {
      name = font.name;
      package = font.package;
      size = terminal.fontSize;
    };

    settings = {
      disable_ligatures = "never";
      cursor_shape = terminal.cursor;
      cursor_blink_interval = 0;
    };
  };
}

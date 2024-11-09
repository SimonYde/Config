{ config, lib, ... }:
let
  terminal = config.syde.terminal;
  font = config.syde.theming.fonts.monospace;
in
{
  programs.kitty = {
    font = lib.mkForce {
      name = ''family="${font.name}" style=Regular'';
      package = font.package;
      size = terminal.fontSize;
    };

    settings = {
      bold_font = ''family="${font.name}" style=Bold'';
      italic_font = ''family="${font.name}" style=Italic'';
      bold_italic_font = ''family="${font.name}" style="Bold Italic"'';
      disable_ligatures = "never";
      cursor_shape = terminal.cursor;
      cursor_blink_interval = 0;
    };
  };
}

{ config, lib, ... }:
let
  terminal = config.syde.terminal;
  cfg = config.programs.kitty;
in
{
  config = lib.mkIf cfg.enable {
    programs.kitty = {
      settings = {
        disable_ligatures = "never";
        cursor_shape = terminal.cursor;
        cursor_blink_interval = 0;
      };
    };
  };
}

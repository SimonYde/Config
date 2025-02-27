{ config, lib, ... }:
let
  cfg = config.programs.kitty;
in
{
  config = lib.mkIf cfg.enable {
    programs.kitty = {
      settings = {
        disable_ligatures = "never";
        cursor_shape = "beam";
        cursor_blink_interval = 0;
      };
    };
  };
}

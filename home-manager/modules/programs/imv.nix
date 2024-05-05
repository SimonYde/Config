{ config, lib, ... }:
let
  cfg = config.programs.imv;
in

{
  config = lib.mkIf cfg.enable {
    programs.imv = {
      settings = with config.colorScheme.palette; {
        options = {
          background = base00;
          overlay_background_color = base01;
          overlay_text_color = base05;
        };
      };
    };
  };
}

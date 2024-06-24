{ lib, config, ... }:

let
  cfg = config.programs.mangohud;
in
{
  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      settingsPerApplication = {
        mpv = {
          no_display = true;
        };
      };
    };
  };
}

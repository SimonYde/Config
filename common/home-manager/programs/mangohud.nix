{ lib, config, ... }:

let
  inherit (lib) mkForce;
  cfg = config.programs.mangohud;
in
{
  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      settings = {
        background_alpha = mkForce 0.6;
        font_size = mkForce 13;
        font_scale = mkForce 1.0;
      };
      settingsPerApplication = {
        mpv = {
          no_display = true;
        };
      };
    };
  };
}

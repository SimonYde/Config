{ lib, ... }:

let
  inherit (lib) mkForce;
in
{
  programs.mangohud = {
    enable = true;
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
}

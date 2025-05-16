{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionals mkIf mkEnableOption;
  cfg = config.syde.daw;
in
{
  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        lsp-plugins
        yabridge
        yabridgectl
      ]
      ++ optionals cfg.reaper.enable (
        with pkgs;
        [
          reaper
          reaper-reapack-extension
          reaper-sws-extension
        ]
      );

  };
  options.syde.daw = {
    enable = mkEnableOption "Digital Audio Workstation tools";
    reaper = {
      enable = mkEnableOption "REAPER DAW" // {
        default = true;
      };
    };
  };
}

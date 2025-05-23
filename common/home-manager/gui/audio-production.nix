{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionals mkIf mkEnableOption;
  cfg = config.syde.audio-production;
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
      ++ optionals cfg.reaper.enable [
        reaper
        reaper-reapack-extension
        reaper-sws-extension
      ];
  };

  options.syde.audio-production = {
    enable = mkEnableOption "tools for audio production";
    reaper = {
      enable = mkEnableOption "REAPER DAW" // {
        default = true;
      };
    };
  };
}

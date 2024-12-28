{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.programs.ghostty;
in
{
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ghostty
    ];
  };

  options.programs.ghostty = {
    enable = mkEnableOption "Ghostty Terminal Emulator";
  };
}

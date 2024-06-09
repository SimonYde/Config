{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    types
    mkOption
    ;
  cfg = config.syde.programs.thunar;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xfce.thunar
      xfce.exo
      gvfs
    ];

    xdg.configFile."xfce4/helpers.rc".text = ''
      TerminalEmulator=${config.syde.terminal.emulator}
    '';

    syde.file-manager = mkIf cfg.defaultFilemanager "thunar";
  };

  options.syde.programs.thunar = {
    enable = mkEnableOption "Thunar file manager";
    defaultFilemanager = mkOption {
      type = types.bool;
      default = false;
    };
  };
}

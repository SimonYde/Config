{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkIf
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
      TerminalEmulator=${cfg.terminal}
    '';
  };

  options.syde.programs.thunar = {
    enable = mkEnableOption "Thunar file manager";
    terminal = mkOption {
      type = types.str;
      default = "${config.syde.terminal.emulator}";
      description = "The terminal emulator to open from within Thunar";
    };
  };
}

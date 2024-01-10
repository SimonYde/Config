{ lib, config, pkgs, ... }:

let
  cfg = config.programs.syde.thunar;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      xfce.thunar
      xfce.exo
    ];

    xdg.configFile."xfce4/helpers.rc".text = "TerminalEmulator=${cfg.terminal}";
  };

  options.programs.syde.thunar = {
    enable = lib.mkEnableOption "Thunar file manager";
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "${config.syde.terminal.emulator}";
      description = "The terminal emulator to open from within Thunar";
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    types
    mkForce
    mkIf
    mkEnableOption
    mkOption
    mkDefault
    optionals
    ;
  cfg = config.syde.desktop.cosmic;
in
{
  config = mkIf cfg.enable {

    qt.enable = mkForce false;

    programs = {
      imv.enable = true; # Image viewer
    };

    syde.desktop.cosmic.files.enable = mkDefault true;
    syde.programs.thunar.enable = mkDefault false;

    home.packages =
      with pkgs;
      [
        wl-clipboard # clipboard manager
      ]
      ++ optionals cfg.files.enable [ cosmic-files ];

    syde.desktop.cosmic.files.defaultFilemanager = mkDefault cfg.files.enable;
    syde.gui.file-manager = mkIf (cfg.files.defaultFilemanager && cfg.files.enable) "com.system76.CosmicFiles";
    syde.terminal.opacity = mkForce 1.0;
  };

  options.syde.desktop.cosmic = {
    enable = mkEnableOption "Cosmic DE";
    files = {
      enable = mkEnableOption "Cosmic Files";
      defaultFilemanager = mkOption {
        description = "Whether to use Cosmic Files as default file-manager";
        type = types.bool;
        default = false;
      };
    };
  };
}

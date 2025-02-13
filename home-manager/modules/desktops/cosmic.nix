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
    services.gammastep.enable = mkForce false; # TODO: find night-light alternative

    home.packages = with pkgs; [
      wl-clipboard # clipboard manager
      (mkIf cfg.files.enable cosmic-files)
    ];

    syde.desktop.cosmic.files.defaultFilemanager = mkDefault cfg.files.enable;
    syde.gui.file-manager = mkIf (cfg.files.defaultFilemanager && cfg.files.enable) {
      mime = "com.system76.CosmicFiles";
      package = pkgs.cosmic-files;
    };
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

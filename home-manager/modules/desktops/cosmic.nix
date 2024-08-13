{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkForce mkIf mkEnableOption;
  cfg = config.syde.desktop.cosmic;
in
{
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      wl-clipboard # clipboard manager
    ];

    qt.enable = mkForce false;
    gtk.enable = mkForce false;

    programs = {
      imv.enable = true; # Image viewer
    };

  };

  options.syde.desktop.cosmic = {
    enable = mkEnableOption "Cosmic DE";
  };
}

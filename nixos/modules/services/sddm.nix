{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.displayManager.sddm;
  catppuccin-sddm = pkgs.callPackage ../../packages/catppuccin-sddm.nix {};
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      catppuccin-sddm
      libsForQt5.qt5.qtgraphicaleffects
      libsForQt5.qt5.qtsvg
      libsForQt5.qt5.qtquickcontrols2
    ];

    services.displayManager = {
      autoLogin = {
        user = config.syde.user;
        enable = true;
      };
      sddm = {
        wayland.enable = true;
        theme = "catppuccin-mocha";
      };
    };
  };
}

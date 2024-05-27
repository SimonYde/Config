{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.displayManager.sddm;
  has_xorg = config.services.xserver.windowManager.i3.enable;
  has_wayland =
    config.programs.sway.enable || config.programs.hyprland.enable || config.programs.river.enable;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (pkgs.callPackage ../../packages/catppuccin-sddm.nix { })
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
        wayland.enable = !has_xorg && has_wayland;
        theme = "catppuccin-mocha";
      };
    };
  };
}

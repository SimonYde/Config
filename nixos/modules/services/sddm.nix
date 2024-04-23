{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.displayManager.sddm;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # inputs.sddm-catppuccin.packages.${pkgs.hostPlatform.system}.sddm-catppuccin
      (pkgs.callPackage ../../packages/catppuccin-sddm.nix {})
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
        wayland.enable =
          config.programs.sway.enable
          || config.programs.hyprland.enable
          || config.programs.river.enable;
        theme = "catppuccin-mocha";
      };
    };
  };
}

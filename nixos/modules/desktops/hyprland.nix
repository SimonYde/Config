{ inputs, config, lib, pkgs, ... }:

let cfg = config.programs.hyprland; in
{
  config = lib.mkIf cfg.enable {
    xdg.portal = {
      xdgOpenUsePortal = true;
      enable = true;
      wlr.enable = true;
      config = {
        common.default = [
          "gtk"
        ];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
    programs.hyprland = {
      xwayland.enable = true;
    };

    services.xserver.enable = true;

    security.pam.services.swaylock = {}; # Won't unlock otherwise, see nixpkgs#89019

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };

    environment.systemPackages = with pkgs; [
      qt6.qtwayland
    ];
  };

  imports = [
    inputs.hyprland.nixosModules.default
  ];
}

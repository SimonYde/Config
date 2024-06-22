{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.programs.hyprland;
in
{
  config = mkIf cfg.enable {
    xdg.portal = {
      xdgOpenUsePortal = false;
      enable = true;
      config = {
        common.default = [
          "gtk"
          "hyprland"
          "*"
        ];
      };
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    programs.hyprland.xwayland.enable = true;

    programs.dconf.enable = true;
    services = {
      displayManager.sddm.enable = true;
      xserver = {
        enable = false;
        displayManager.lightdm.enable = false;
        displayManager.gdm.enable = false;
      };
    };

    security.pam.services.swaylock = { }; # swaylock cannot unlock otherwise, see nixpkgs#89019
    security.pam.services.hyprlock = { }; # hyprlock cannot unlock otherwise, see nixpkgs#89019

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = 1;
      WLR_DRM_NO_ATOMIC = 1; # Tearing support, may not be needed in the future, see hyprland docs
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    };

    environment.systemPackages = with pkgs; [
      qt6.qtwayland
      libsForQt5.qt5.qtwayland
      xwaylandvideobridge
    ];

    systemd = mkIf config.security.polkit.enable {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}

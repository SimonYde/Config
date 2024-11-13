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
          "hyprland"
          "gtk"
        ];
      };
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    programs = {
      hyprland.xwayland.enable = true;
      dconf.enable = true;
    };

    services = {
      blueman.enable = true;
      xserver = {
        enable = false;
        displayManager.lightdm.enable = false;
        displayManager.gdm.enable = false;
      };
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${lib.getExe pkgs.hyprland}";
        };
        initial_session = {
          command = lib.getExe pkgs.hyprland;
          user = config.syde.user;
        };
      };
    };

    security.pam.services.swaylock = { }; # swaylock cannot unlock otherwise, see nixpkgs#89019
    security.pam.services.hyprlock = { }; # NOTE: Could alternatively use the NixOS module for hyprlock

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = 1;
      WLR_DRM_NO_ATOMIC = 1; # Tearing support, may not be needed in the future, see hyprland docs
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    };

    environment.systemPackages = with pkgs; [
      qt6.qtwayland
      libsForQt5.qt5.qtwayland
    ];

    systemd.user.services = {
      hyprpolkitagent = mkIf config.security.polkit.enable {
        description = "hyprpolkitagent";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}

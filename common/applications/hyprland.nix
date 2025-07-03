{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  inherit (lib) mkIf getExe;
  command = "${getExe config.programs.hyprland.package} &> /dev/null";
  cfg = config.programs.hyprland;
in
{
  config = mkIf cfg.enable {
    home-manager.users.${username}.imports = [ ../home-manager/gui/hyprland.nix ];

    environment.systemPackages = with pkgs; [
      hyprland-qtutils
    ];

    services = {
      blueman.enable = config.hardware.bluetooth.enable;

      greetd = {
        enable = true;

        settings.initial_session = {
          inherit command;
          user = username;
        };
      };
    };

    programs.regreet.enable = true;

    security.pam.services.hyprlock = { };

    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      XKB_DEFAULT_LAYOUT = config.services.xserver.xkb.layout;
      XKB_DEFAULT_VARIANT = config.services.xserver.xkb.variant;
    };

    systemd.user.services.hyprpolkitagent = mkIf config.security.polkit.enable {
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
}

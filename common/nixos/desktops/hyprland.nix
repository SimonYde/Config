{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;
  inherit (config.syde) user;
  cfg = config.programs.hyprland;
in
{
  config = mkIf cfg.enable {
    services.blueman.enable = config.hardware.bluetooth.enable;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${getExe cfg.package}";
        };
        initial_session = {
          command = getExe cfg.package;
          inherit (config.syde) user;
        };
      };
    };

    security.pam.services.hyprlock = { };

    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    };

    environment.systemPackages = with pkgs; [
      hyprland-qtutils
    ];

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

    home-manager.users.${user}.imports = [ ../../home-manager/gui/hyprland ];
  };
}

{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  inherit (lib) mkIf getExe;
  cfg = config.programs.hyprland;
in
{
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      imports = [ ../home-manager/gui/hyprland.nix ];

      wayland.windowManager.hyprland.extraConfig = ''
        pcall(require, 'machines.' .. '${config.networking.hostName}')
      '';

      programs.hyprlock.settings.auth.fingerprint.enabled = config.services.fprintd.enable;
    };

    # Allows lua stub file to be accessed from /run/current-system/sw/share/hypr
    environment.pathsToLink = [ "/share/hypr" ];

    services = {
      blueman.enable = config.hardware.bluetooth.enable;

      greetd = {
        enable = true;

        settings.initial_session = {
          command = "uwsm start hyprland-uwsm.desktop";
          user = username;
        };
      };
    };

    services.displayManager.regreet.enable = true;
    programs.hyprland.withUWSM = true;

    security.pam.services.hyprlock = { };
    security.pam.services.swaylock = { };

    environment.sessionVariables = {
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    };
  };
}

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
    };

    # Allows lua stub file to be accessed from /run/current-system/sw/share/hypr
    environment.pathsToLink = [ "/share/hypr" ];

    services = {
      greetd = {
        enable = true;
        settings.initial_session = {
          user = username;
          command = "${getExe pkgs.uwsm} start hyprland-uwsm.desktop";
        };
      };
    };

    programs.hyprland.withUWSM = true;

    security.pam.services = {
      greetd.oo7.enable = true;
      greetd.fprintAuth = lib.mkForce false;
      quickshell.fprintAuth = config.services.fprintd.enable;
      polkit-1.fprintAuth = config.services.fprintd.enable;
    };

    environment.sessionVariables = {
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    };
  };
}

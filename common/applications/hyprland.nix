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
    home-manager.users.${username}.imports = [ ../home-manager/gui/hyprland.nix ];

    environment.systemPackages = with pkgs; [
      hyprland-qtutils
    ];

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

    programs.regreet.enable = true;
    programs.hyprland.withUWSM = true;

    security.pam.services.hyprlock = { };

    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      XKB_DEFAULT_LAYOUT = config.services.xserver.xkb.layout;
      XKB_DEFAULT_VARIANT = config.services.xserver.xkb.variant;
    };
  };
}

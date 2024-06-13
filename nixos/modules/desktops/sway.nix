{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.sway;
in
{
  config = lib.mkIf cfg.enable {
    xdg.portal = {
      xdgOpenUsePortal = false;
      enable = true;
      wlr.enable = true;
      config = {
        common.default = [
          "gtk"
          "*"
        ];
      };
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
    programs.sway = {
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;
      extraOptions = [ "--unsupported-gpu" ];
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = 1;
      MOZ_ENABLE_WAYLAND = 1;
    };

    services.dbus.enable = true;
    services.displayManager = {
      defaultSession = "sway";
      sddm.enable = true;
    };
  };
}

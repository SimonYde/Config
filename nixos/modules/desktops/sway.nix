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
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    programs.sway = {
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;

      extraSessionCommands = ''
        export WLR_NO_HARDWARE_CURSORS=1
        export MOZ_ENABLE_WAYLAND=1
      '';
      extraOptions = [ "--unsupported-gpu" ];
    };

    services.dbus.enable = true;

    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession = "sway";
        sddm.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
      grim
      slurp
    ];
  };
}

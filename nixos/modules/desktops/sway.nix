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
    programs.sway = {
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;
      extraOptions = [ "--unsupported-gpu" ];
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = 1;
    };

    services.dbus.enable = true;
    services.displayManager = {
      defaultSession = "sway";
      sddm.enable = true;
    };
  };
}

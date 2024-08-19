{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.xserver.windowManager.i3;
in
{
  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession = "none+i3";
        sddm.enable = true;
        sddm.wayland.enable = lib.mkForce false;
      };
      windowManager.i3 = {
        package = pkgs.i3-gaps;
      };
    };

    programs.dconf.enable = true;
  };
}

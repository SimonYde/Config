{ config, lib, ... }:

let cfg = config.services.xserver.displayManager.sddm; in
{
  config = lib.mkIf cfg.enable {
    services.xserver.displayManager = {
      autoLogin = {
        user = "syde";
        enable = false;
      };
      sddm = {
        wayland.enable = true;
      };
    };
  };
}

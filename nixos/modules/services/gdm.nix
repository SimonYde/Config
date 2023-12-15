{ config, lib, ... }:

let cfg = config.services.xserver.displayManager.gdm; in
{
  config = lib.mkIf cfg.enable {
    services.xserver.displayManager = {
      autoLogin = {
        user = "syde";
        enable = true;
      };
      gdm = {
        wayland = true;
      };
    };
  };
}

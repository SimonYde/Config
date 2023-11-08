{ config, pkgs, lib, ... }:

let cfg = config.services.xserver.displayManager.gdm; in
{
  config.services.xserver.displayManager = lib.mkIf cfg.enable {
    autoLogin = {
      user = "syde";
      enable = true;
    };
    gdm = {
      wayland = true;
    };
  };
}

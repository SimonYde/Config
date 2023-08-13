{ config, pkgs, lib, ... }:

{
  config.services.xserver.displayManager = {
    autoLogin = {
      user = "syde";
      enable = true;
    };
    gdm = {
      wayland = true;
    };
  };
}

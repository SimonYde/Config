{ config, pkgs, lib, ... }:

{
  config.services.xserver.displayManager = {
    autoLogin = {
      user = "syde";
      enable = true;
    };
    lightdm = {
      greeters = {
        gtk = {
          enable = true;
        };
      };
    };
  };
}

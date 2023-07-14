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
          theme.name = "Catppuccin-Mocha-Compact-Lavender-Dark";
          theme.package = pkgs.catppuccin-gtk.override {
            accents = [ "lavender" ];
            size = "compact";
            tweaks = [ "rimless" ];
            variant = "mocha";
          };
        };
      };
    };
  };
}

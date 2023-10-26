{ config, pkgs, lib, ... }:

{
  config.services.xserver.displayManager= lib.mkIf config.services.xserver.displayManager.lightdm.enable {
      autoLogin = {
        user = "syde";
        enable = true;
      };
      lightdm = {
        greeters = {
          gtk = {
            enable = true;
            theme = {
              name = "Catppuccin-Mocha-Compact-Lavender-Dark";
              package = pkgs.catppuccin-gtk.override {
                accents = [ "lavender" ];
                size = "compact";
                tweaks = [ "rimless" ];
                variant = "mocha";
              };
            };
            cursorTheme = {
              name = "Catppuccin-Mocha-Dark-Cursors";
              package = pkgs.catppuccin-cursors.mochaDark;
            };
          };
        };
      };
    };
}

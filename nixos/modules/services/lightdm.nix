{ config, lib, ... }:

let
  theme = config.themes;
  cfg = config.services.xserver.displayManager.lightdm;
in
{
  config.services.xserver.displayManager = lib.mkIf cfg.enable {
    autoLogin = {
      user = "syde";
      enable = true;
    };
    lightdm = {
      greeters = {
        gtk = {
          enable = true;
          theme = {
            name = if theme.prefer-dark then theme.gtk.darkTheme else theme.gtk.lightTheme;
            package = theme.gtk.package;
          };
          cursorTheme = {
            name = theme.cursorTheme.name;
            package = theme.cursorTheme.package;
          };
        };
      };
    };
  };
}

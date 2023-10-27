{ config, lib, ... }:

let theme = config.themes; in

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

{
  config,
  lib,
  ...
}: let
  theming = config.syde.theming;
  cfg = config.services.xserver.displayManager.lightdm;
in {
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
            name =
              if theming.prefer-dark
              then theming.gtk.darkTheme
              else theming.gtk.lightTheme;
            package = theming.gtk.package;
          };
          cursorTheme = {
            name = theming.cursorTheme.name;
            package = theming.cursorTheme.package;
          };
        };
      };
    };
  };

  imports = [../../../home-manager/modules/theming.nix];
}

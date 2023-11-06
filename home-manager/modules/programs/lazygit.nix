{ config, ... }:

let
  theme = config.themes;
  flavour = theme.flavour;
in
{
  programs.lazygit = {
    settings = {
      gui = {
        # use the mocha catppuccin theme
        theme = with theme.catppuccin.${flavour}; {
          lightTheme = theme.prefer-dark;
          activeBorderColor         = [ green ]; # Green
          inactiveBorderColor       = [ text ]; # Text
          optionsTextColor          = [ blue ]; # Blue
          selectedLineBgColor       = [ surface0 ]; # Surface0
          selectedRangeBgColor      = [ surface0 ]; # Surface0
          cherryPickedCommitBgColor = [ teal ]; # Teal
          cherryPickedCommitFgColor = [ blue ]; # Blue
          unstagedChangesColor      = [ red ]; # Red
        };
      };
    };
  };
}

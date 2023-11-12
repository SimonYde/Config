{ config, ... }:

let
  colorScheme = config.colorScheme;
in
{
  programs.lazygit = {
    settings = {
      gui = {
        # use the mocha catppuccin theme
        theme = with colorScheme.colors; {
          lightTheme = colorScheme.kind == "light";
          activeBorderColor         = [ base0B ]; # Green
          inactiveBorderColor       = [ base05 ]; # Text
          optionsTextColor          = [ base0D ]; # Blue
          selectedLineBgColor       = [ base02 ]; # Surface0
          selectedRangeBgColor      = [ base02 ]; # Surface0
          cherryPickedCommitBgColor = [ base0C ]; # Teal
          cherryPickedCommitFgColor = [ base0D ]; # Blue
          unstagedChangesColor      = [ base08 ]; # Red
        };
      };
    };
  };
}

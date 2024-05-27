{ config, ... }:
let
  variant = config.colorScheme.variant;
  palette = config.colorScheme.palette;
in
{
  programs.lazygit = {
    settings = {
      gui = {
        # use the mocha catppuccin theme
        theme = with palette; {
          lightTheme = variant == "light";
          activeBorderColor = [ base0B ]; # Green
          inactiveBorderColor = [ base05 ]; # Text
          optionsTextColor = [ base0D ]; # Blue
          selectedLineBgColor = [ base02 ]; # Surface0
          selectedRangeBgColor = [ base02 ]; # Surface0
          cherryPickedCommitBgColor = [ base0C ]; # Teal
          cherryPickedCommitFgColor = [ base0D ]; # Blue
          unstagedChangesColor = [ base08 ]; # Red
        };
      };
    };
  };
}

{
  config,
  inputs,
  ...
}:

let
  stylix = inputs.stylix;
  theming = config.syde.theming;
  fonts = theming.fonts;
in
{
  config = {
    stylix = {
      image = ../../../assets/backgrounds/rose-pine/chainsaw_makima.png;
      base16Scheme = config.colorScheme.palette;
      targets = {
        sway.enable = false;
        swaylock.enable = false;
        vim.enable = false;
        waybar.enable = false;
        zellij.enable = false;
        zathura.enable = false;
      };
      cursor = {
        package = theming.cursor.package;
        name = theming.cursor.name;
        size = 24;
      };
      fonts = {
        monospace = fonts.monospace;
        serif = fonts.serif;
        sansSerif = fonts.sansSerif;
        emoji = fonts.emoji;
        sizes = {
          terminal = 12;
          # popups = 12;
        };
      };

      opacity = {
        terminal = config.syde.terminal.opacity;
      };
    };
  };

  imports = [ stylix.homeManagerModules.stylix ];
}
{pkgs, config, inputs, ...}:

let
  stylix = inputs.stylix;
  theming = config.syde.theming;
in
{
  config = {
    stylix = {
      image = ../../../assets/backgrounds/rose-pine/chainsaw_makima.png;
      base16Scheme = config.colorScheme.palette;
      targets = {
        vim.enable = false;
        waybar.enable = false;
        swaylock.enable = false;
        zellij.enable = false;
      };
      cursor = {
        package = theming.cursorTheme.package;
        name = theming.cursorTheme.name;
        size = 24;
      };
      fonts = {
        monospace = {
          name = "JetBrains Mono Nerd Font Mono";
          package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
        };
        sansSerif = {
          name = "JetBrains Mono Nerd Font Propo";
          package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
        };
        serif = {
          name = "Gentium Plus";
          package = pkgs.gentium;
        };
        sizes = {
          terminal = 12;
          # popups = 12;
        };
      };

      opacity = {
        terminal = config.syde.terminal.opacity;
      };
    };

    syde.terminal.font = config.stylix.fonts.monospace.name;
  };

  imports = [
    stylix.homeManagerModules.stylix
  ];
}

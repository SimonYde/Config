{ inputs, pkgs, config, ... }:

let
  flavour = config.syde.theming.flavour;
in
{
  programs.bat = {
    config = {
      theme = "catppuccin";
    };
    themes = {
      catppuccin = {
        src = inputs.catppuccin-bat;
        file = "Catppuccin-${flavour}.tmTheme";
      };
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };

  home.sessionVariables = {
    MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat -l man -p'";
  };
}

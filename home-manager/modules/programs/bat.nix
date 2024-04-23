{
  inputs,
  pkgs,
  config,
  ...
}: let
  flavour =
    if config.syde.theming.flavour == "mocha"
    then "Mocha"
    else "Latte";
in {
  programs.bat = {
    config = {
      theme = "catppuccin";
      pager = "less -FR";
    };
    themes = {
      catppuccin = {
        src = inputs.catppuccin-bat;
        file = "/themes/Catppuccin ${flavour}.tmTheme";
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
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };
}

{ pkgs, config, ... }:

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
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d168";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
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

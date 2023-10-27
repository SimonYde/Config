{ pkgs, config, ... }:

let
  theme = config.themes.flavour;
in
{
  programs.bat = {
    config = {
      theme = "Catppuccin";
    };
    themes = {
      Catppuccin = builtins.readFile (pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d168";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        } + "/Catppuccin-${theme}.tmTheme");
    };
  };
}

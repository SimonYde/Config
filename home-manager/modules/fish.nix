{ pkgs, config, ... }:

let
  theme = config.themes.flavour;
in
{
  programs.fish = {
    shellInit = ''
      any-nix-shell fish --info-right | source
      set fish_greeting ""
      fish_config theme choose ${theme}
    '';
  };

  home.file =
    let
      catppuccin = pkgs.fetchFromGitHub {
        owner = "Catppuccin";
        repo = "fish";
        rev = "91e6d67";
        sha256 = "sha256-l9V7YMfJWhKDL65dNbxaddhaM6GJ0CFZ6z+4R6MJwBA=";
      };
    in
    {
      "${config.xdg.configHome}/fish/themes/mocha.theme" = {
        enable = config.programs.fish.enable;
        source = catppuccin + "/themes/Catppuccin Mocha.theme";
      };
      "${config.xdg.configHome}/fish/themes/latte.theme" = {
        enable = config.programs.fish.enable;
        source = catppuccin + "/themes/Catppuccin Latte.theme";
      };
    };
}

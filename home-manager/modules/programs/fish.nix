{ pkgs, config, lib, ... }:

let
  theme = config.themes.flavour;
  catppuccin = config.themes.catppuccin;
in
{
  programs.fish = {
    shellInit = with catppuccin.${theme}; ''
      any-nix-shell fish --info-right | source
      set fish_greeting ""
      fish_config theme choose ${theme}
      export SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS --color=fg:${text},matched:${surface0},matched_bg:${flamingo},current:${text},current_bg:${surface1},current_match:${base},current_match_bg:${rosewater},spinner:${green},info:${mauve},prompt:${blue},cursor:${red},selected:${lavender},header:${teal},border:${surface2}"
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
      fish_config = "${config.xdg.configHome}/fish";
    in
    lib.mkIf config.programs.fish.enable
    {
      "${fish_config}/themes/mocha.theme" = {
        source = catppuccin + "/themes/Catppuccin Mocha.theme";
      };
      "${fish_config}/themes/latte.theme" = {
        source = catppuccin + "/themes/Catppuccin Latte.theme";
      };
    };
}

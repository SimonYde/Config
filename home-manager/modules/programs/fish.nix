{ pkgs, config, lib, ... }:

let
  flavour = config.themes.flavour;
  cfg = config.programs.fish;
in
{
  programs.fish = {
    shellInit = ''
      any-nix-shell fish --info-right | source
      set fish_greeting ""
      fish_config theme choose ${flavour}
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
    lib.mkIf cfg.enable
      {
        "${fish_config}/themes/mocha.theme" = {
          source = catppuccin + "/themes/Catppuccin Mocha.theme";
        };
        "${fish_config}/themes/latte.theme" = {
          source = catppuccin + "/themes/Catppuccin Latte.theme";
        };
      };
}

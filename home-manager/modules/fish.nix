{ pkgs, config, ... }:

{
  programs.fish = {
    shellInit = ''
      any-nix-shell fish --info-right | source
      set fish_greeting ""
    '';
      # fish_config theme save Catppuccin-Mocha
  };
  home.file = {
    "${config.xdg.configHome}/fish/themes/Catppuccin-Mocha.theme".source = 
          (pkgs.fetchFromGitHub {
            owner = "Catppuccin";
            repo = "fish";
            rev = "91e6d67";
            sha256 = "sha256-l9V7YMfJWhKDL65dNbxaddhaM6GJ0CFZ6z+4R6MJwBA=";
          } + "/themes/Catppuccin Mocha.theme");
  }; 
}

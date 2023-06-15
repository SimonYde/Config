{ config, ... }:

{
  programs.fish = {
    shellAliases = config.syde.terminal.aliases;
    shellInit = ''
      any-nix-shell fish --info-right | source
    '';
  };
  home.file = {
    "${config.xdg.configHome}/fish/themes/Catppuccin-Mocha.theme".source = ../../fish/Catppuccin-Mocha.theme;
  }; 
}

{ config, ... }:

{
  programs.fish = {
    shellAliases = config.syde.terminal.aliases;
    shellInit = ''
      any-nix-shell fish --info-right | source
    '';
  };
}

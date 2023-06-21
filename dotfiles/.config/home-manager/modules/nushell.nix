{ config, pkgs, ...}:

{
  programs.nushell = {
    shellAliases = config.syde.terminal.aliases;
  };
}

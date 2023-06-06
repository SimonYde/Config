{ config, pkgs, ...}:

{
  programs.nushell = {
    package = pkgs.nushell;
    shellAliases = config.syde.terminal.aliases;
  };
}

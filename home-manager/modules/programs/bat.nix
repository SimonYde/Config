{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.bat;
in
{
  config = lib.mkIf cfg.enable {
    programs.bat = {
      config = {
        # theme = "catppuccin";
        pager = "less -FR";
      };
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];
    };

    home.shellAliases = {
      cat = "bat";
      man = "batman";
    };

    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };
  };
}

{
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
        theme = lib.mkDefault "base16-256";
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

    programs.nushell.extraConfig = # nu
      ''
        alias cat = bat
        alias man = batman
      '';
  };
}

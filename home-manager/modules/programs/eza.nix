{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf getExe;
  cfg = config.programs.eza;
in
{
  config = mkIf cfg.enable {
    programs.eza = {
      icons = "auto";
    };

    programs.nushell.shellAliases = {
      lt = "${getExe pkgs.eza} --tree --level=2 --long --icons --git";
    };
  };
}

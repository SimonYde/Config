{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.programs.nix-index.enable {
    programs.nix-index-database.comma.enable = true;
    home.sessionVariables.COMMA_PICKER = lib.getExe pkgs.fzf;
  };

  imports = [ inputs.nix-index-database.hmModules.nix-index ];
}

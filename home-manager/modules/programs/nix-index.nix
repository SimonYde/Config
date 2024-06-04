{ inputs, config, lib, ... }:
{
  config = lib.mkIf config.programs.nix-index.enable {
    programs.nix-index-database = {
      comma.enable = true;
    };
    home.sessionVariables = {
      COMMA_PICKER = "fzf";
    };
  };

  imports = [ inputs.nix-index-database.hmModules.nix-index ];
}

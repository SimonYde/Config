{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.programs.nushell;
in
{
  config = mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.vimPlugins; [
      nvim-nu
    ];
    programs.carapace.enable = true;

    programs.starship.settings.character.format = " ";
    programs.nushell = {
      configFile.source = ./config.nu;
    };
  };
}

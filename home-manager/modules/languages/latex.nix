{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.syde.programming.latex.enable {
    home.packages = with pkgs; [
      texlab
      tectonic
      ltex-ls
    ];
    programs.neovim.plugins = with pkgs.vimPlugins; [
      ltex_extra-nvim
    ];
  };

  options.syde.programming.latex = {
    enable = lib.mkEnableOption "Latex";
  };
}

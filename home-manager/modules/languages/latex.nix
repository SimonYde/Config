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
      # ltex-ls
    ];
    programs.neovim.plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.latex
      ]))
      # ltex_extra-nvim
    ];
  };

  options.syde.programming.latex = {
    enable = lib.mkEnableOption "Latex";
  };
}

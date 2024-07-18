{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.syde.programming.typst;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      typst
      typst-lsp
      typstfmt
      typstyle
      polylux2pdfpc # Converting slides into `.pdfpc` file with speaker notes
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ typst-vim ];
  };

  options.syde.programming.typst = {
    enable = lib.mkEnableOption "Typst language support";
  };
}

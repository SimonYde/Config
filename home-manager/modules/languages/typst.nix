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
      tinymist
      # typst-lsp
      typstyle
      polylux2pdfpc # Converting slides into `.pdfpc` file with speaker notes
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ ];
  };

  options.syde.programming.typst = {
    enable = lib.mkEnableOption "Typst language support";
  };
}

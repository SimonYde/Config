{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.syde.programming.ocaml;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ocamlPackages.ocamlformat
      ocamlPackages.ocaml-lsp
      ocaml
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.ocaml
        p.commonlisp
        p.ocaml-interface
      ]))
    ];

    programs.opam.enable = true;
  };

  options.syde.programming.ocaml = {
    enable = mkEnableOption "OCaml development";
  };
}

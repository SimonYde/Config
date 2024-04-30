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

    programs.opam.enable = true;
  };

  options.syde.programming.ocaml = {
    enable = mkEnableOption "Ocaml development";
  };
}

{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.syde.programming;
in
{
  config = mkIf cfg.enable {
    programs = {
      # Terminal Editors
      helix.enable = true;
      neovim.enable = true;
    };

    syde.programming = {
      bash.enable = true;
      cpp.enable = true;
      gleam.enable = true;
      go.enable = true;
      java.enable = false;
      latex.enable = true;
      scala.enable = false;
      lua.enable = true;
      nix.enable = true;
      ocaml.enable = false;
      python.enable = true;
      rust.enable = true;
      typst.enable = true;
    };

    home.packages = with pkgs; [
      kattis-cli
      kattis-test
    ];
  };

  options.syde.programming = {
    enable = mkEnableOption "Development support";
  };
}

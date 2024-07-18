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
      helix.enable = false;
      neovim.enable = true;
    };

    syde.programming = {
      java.enable = false;
      bash.enable = true;
      latex.enable = true;
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
      imhex
    ];

    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.configHome}/cargo";
      GOPATH = "${config.xdg.dataHome}/go";
    };
  };

  options.syde.programming = {
    enable = mkEnableOption "Development support";
  };
}

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
      bash.enable = true;
      cpp.enable = false;
      gleam.enable = false;
      go.enable = false;
      java.enable = false;
      latex.enable = true;
      lua.enable = true;
      nix.enable = true;
      ocaml.enable = false;
      python.enable = true;
      rust.enable = true;
      scala.enable = false;
      typst.enable = true;
      zig.enable = true;
    };

    home.packages = with pkgs; [
      kattis-cli
      kattis-test
    ];
  };

  options.syde.programming = {
    enable = mkEnableOption "Development support";
  };

  imports = [
    ./bash.nix
    ./cpp.nix
    ./gleam.nix
    ./go.nix
    ./java.nix
    ./latex.nix
    ./lua.nix
    ./nix.nix
    ./ocaml.nix
    ./python.nix
    ./scala.nix
    ./rust.nix
    ./typst.nix
    ./zig.nix
  ];
}

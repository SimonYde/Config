{ pkgs, config, lib, ... }:

let cfg = config.syde.programming; in
{
  config = {
    programs = {
      # Terminal Editors
      helix.enable  = false;
      neovim.enable = true;

      # Other
      opam.enable = false;
    };

    syde.programming = {
      latex.enable  = false;
      python.enable = false;
      rust.enable   = true;
      typst.enable  = true;
      nix.enable    = true;
      java.enable   = false;
    };

    home.packages = with pkgs; [
      kattis-cli
      kattis-test
    ];

    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.configHome}/cargo";
      GOPATH     = "${config.xdg.dataHome}/go";
    };
  };
}

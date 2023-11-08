{ pkgs, config, lib, ... }:

let cfg = config.syde.programming; in
{
  config = {
    programs = {
      # Terminal Editors
      helix.enable  = false;
      neovim.enable = true;

      # Other
      opam.enable = true;
    };

    syde.programming = {
      latex.enable  = false;
      python.enable = cfg.kattis.enable;
      rust.enable   = true;
      kattis.enable = true;
      typst.enable  = true;
      nix.enable    = true;
      java.enable   = false;
    };

    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.configHome}/cargo";
      GOPATH     = "${config.xdg.dataHome}/go";
    };

    home.file =
      let
        kattis-cli = (pkgs.fetchFromGitHub {
          owner  = "kattis";
          repo   = "kattis-cli";
          rev    = "be7fee7";
          sha256 = "sha256-R9wuxsVhNGkSVgTze6mR1mXYKXo5rj8LVVU3lTm2jTg=";
        });
      in
      lib.mkIf cfg.kattis.enable {
        "${config.home.homeDirectory}/.local/bin/kattis" = {
          source = kattis-cli + "/kattis";
        };
        "${config.home.homeDirectory}/.local/bin/kattis-submit" = {
          source = kattis-cli + "/submit.py";
        };
      };
  };

  options.syde.programming = {
    kattis = {
      enable = lib.mkEnableOption "kattis";
    };
  };

  imports = [
    ./modules/languages
  ];
}

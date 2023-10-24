{ pkgs, inputs, config, ... }:

let cfg = config.syde.programming; in
{
  programs = {
    # Terminal Editors
    helix.enable = false;
    neovim.enable = true;

    # Other
    opam.enable = true;
  };

  syde.programming = {
    latex.enable = false;
    python.enable = true;
    rust.enable = true;
  };

  home.packages = with pkgs; [
    pandoc

    # ---Other LSPs---
    # metals
    # jdt-language-server
    unstable.typst-lsp
    inputs.nil.packages.x86_64-linux.nil
    nixpkgs-fmt
    nodejs-slim_20 # for copilot.lua
  ];

  home.sessionVariables = {
    CARGO_HOME = "${config.xdg.configHome}/cargo";
    GOPATH = "${config.xdg.dataHome}/go";
  };

  home.file =
    let
      kattis-cli = (pkgs.fetchFromGitHub {
        owner = "kattis";
        repo = "kattis-cli";
        rev = "be7fee7";
        sha256 = "sha256-R9wuxsVhNGkSVgTze6mR1mXYKXo5rj8LVVU3lTm2jTg=";
      });
    in
    {
      "${config.home.homeDirectory}/.local/bin/kattis" = {
        source = kattis-cli + "/kattis";
        enable = cfg.python.enable;
      };
      "${config.home.homeDirectory}/.local/bin/submit.py" = {
        source = kattis-cli + "/submit.py";
        enable = cfg.python.enable;
      };
    };

  imports = [
    # ---Languages---
    ./modules/python.nix
    ./modules/rust.nix
    ./modules/latex.nix

    # ---Programs---
    ./modules/zathura.nix
    ./modules/helix.nix
    ./modules/neovim.nix
    ./modules/vscode.nix
  ];
}

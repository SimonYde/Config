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
    python.enable = true;
    rust.enable = true;
  };

  home.packages = with pkgs; [
    # Latex
    texlab
    tectonic
    pandoc
    ltex-ls

    # Other LSPs
    # metals
    # jdt-language-server
    inputs.nil.packages.x86_64-linux.nil
    nixpkgs-fmt
    nodejs-slim_20 # for copilot.lua
  ];

  home.sessionVariables = {
    GOPATH = "${config.xdg.dataHome}/go";
    CARGO_HOME = "${config.xdg.configHome}/cargo";
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
    ./modules/zathura.nix
    ./modules/python.nix
    ./modules/rust.nix
    ./modules/helix.nix
    ./modules/neovim.nix
    ./modules/vscode.nix
  ];
}

{ pkgs, lib, config, ... }:

let
  python-pkgs = with pkgs; [
      (python311.withPackages (ps: with ps; [
        python-lsp-server
        python-lsp-ruff
        pylsp-mypy

        numpy
        sympy
        matplotlib
      ]))
  ];
in

{
  config = lib.mkIf config.syde.programming.python.enable {
    # programs.neovim.extraPackages = python-pkgs;
    # programs.helix.extraPackages = python-pkgs;
    home.packages = python-pkgs;
  };

  options.syde.programming.python = with lib; {
    enable = mkEnableOption "Python language support";
  };
}


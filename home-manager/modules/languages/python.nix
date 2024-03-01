{ pkgs, lib, config, ... }:

{
  config = lib.mkIf config.syde.programming.python.enable {
    home.packages = with pkgs; [
      (python311.withPackages (ps: with ps; [
        python-lsp-server
        python-lsp-black
        python-lsp-ruff
        pylsp-mypy

        numpy
        matplotlib
      ]))
    ];
  };

  options.syde.programming.python = with lib; {
    enable = mkEnableOption "Python language support";
  };
}


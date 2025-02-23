{
  pkgs,
  lib,
  config,
  ...
}:
let
  python-pkgs = pkgs.python312.withPackages (
    ps: with ps; [
      python-lsp-server
      python-lsp-ruff
      pylsp-mypy
      types-requests

      numpy
      pandas
      sympy
      scipy
      matplotlib
      debugpy
      pycryptodome

      flask

      # CTF
      randcrack
      pwntools
    ]
  );
in
{
  config = lib.mkIf config.syde.programming.python.enable {
    home.packages = with pkgs; [
      basedpyright
      python-pkgs
    ];

    programs.ruff = {
      enable = true;
      settings = {
        line-length = 100;
      };
    };

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        nvim-dap-python
      ];
    };
  };

  options.syde.programming.python = {
    enable = lib.mkEnableOption "Python language support";
  };
}

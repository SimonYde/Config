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
      ruff
      python-pkgs
    ];

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

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

      numpy
      pandas
      sympy
      scipy
      matplotlib
      debugpy

      # CTF
      randcrack
      pwntools
    ]
  );
in
{
  config = lib.mkIf config.syde.programming.python.enable {
    home.packages = [ python-pkgs ];

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-dap-python;
          type = "lua";
          config = # lua
            ''
            _G.PYTHON_PATH = '${python-pkgs}/bin/python'
          '';
        }
      ];
    };
  };

  options.syde.programming.python = {
    enable = lib.mkEnableOption "Python language support";
  };
}

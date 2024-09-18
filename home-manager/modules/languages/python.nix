{
  pkgs,
  lib,
  config,
  ...
}:
let
  python-pkgs = pkgs.python311.withPackages (
    ps: with ps; [
      python-lsp-server
      python-lsp-ruff
      pylsp-mypy

      numpy
      pandas
      sympy
      matplotlib
      debugpy
    ]
  );
in
{
  config = lib.mkIf config.syde.programming.python.enable {
    # programs.neovim.extraPackages = python-pkgs;
    # programs.helix.extraPackages = python-pkgs;
    home.packages = [ python-pkgs ];

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [ nvim-dap-python ];
      extraLuaConfig = # lua
        ''
          require('syde.load').later(function()
            require("dap-python").setup("${python-pkgs}/bin/python")
          end)
        '';
    };
  };

  options.syde.programming.python = {
    enable = lib.mkEnableOption "Python language support";
  };
}

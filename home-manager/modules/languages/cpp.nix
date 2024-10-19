{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.syde.programming.cpp;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      libgcc
      clang-tools
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.cpp
        p.c
      ]))
    ];
  };

  options.syde.programming.cpp = {
    enable = lib.mkEnableOption "C++ language tools";
  };
}

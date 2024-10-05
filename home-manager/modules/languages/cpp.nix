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
      clang
      clang-tools
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [  ];
  };

  options.syde.programming.cpp = {
    enable = lib.mkEnableOption "C++ language tools";
  };
}

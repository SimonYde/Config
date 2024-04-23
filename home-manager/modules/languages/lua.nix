{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.syde.programming.lua;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ lua-language-server ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ neodev-nvim ];
  };

  options.syde.programming.lua = {
    enable = lib.mkEnableOption "lua language tools";
  };
}

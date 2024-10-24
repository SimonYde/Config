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
    home.packages = with pkgs; [
      stylua
      lua-language-server
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ ];
  };

  options.syde.programming.lua = {
    enable = lib.mkEnableOption "lua language tools";
  };
}

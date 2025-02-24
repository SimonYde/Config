{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.syde.programming.odin;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ols
      odin
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ ];
  };

  options.syde.programming.odin = {
    enable = lib.mkEnableOption "Odin language tools";
  };
}

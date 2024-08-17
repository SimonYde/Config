{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.syde.programming.go;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      gopls
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ nvim-dap-go ];
  };

  options.syde.programming.go = {
    enable = lib.mkEnableOption "go language tools";
  };
}

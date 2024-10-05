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
      # CLI
      go

      # Debugger
      delve
      # LSP
      gopls
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      # debugging
      nvim-dap-go
    ];

    home.sessionVariables = {
      GOPATH = "${config.xdg.dataHome}/go";
    };
  };

  options.syde.programming.go = {
    enable = lib.mkEnableOption "go language tools";
  };
}

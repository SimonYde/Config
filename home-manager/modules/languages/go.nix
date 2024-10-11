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
      go # CLI
      delve # Debugger
      gopls # LSP
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.go
      ]))
      nvim-dap-go # debugging support
    ];

    home.sessionVariables = {
      GOPATH = "${config.xdg.dataHome}/go";
    };
  };

  options.syde.programming.go = {
    enable = lib.mkEnableOption "go language tools";
  };
}

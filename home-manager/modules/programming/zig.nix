{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.syde.programming.zig;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zls
      zig
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ ];
  };

  options.syde.programming.zig = {
    enable = lib.mkEnableOption "Zig programming language support";
  };
}

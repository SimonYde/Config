{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.syde.programming.gleam;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gleam
      erlang
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.gleam
      ]))
    ];
  };

  options.syde.programming.gleam = {
    enable = lib.mkEnableOption "gleam language tools";
  };
}

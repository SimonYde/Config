{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    ;
  cfg = config.syde.programming.gleam;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gleam
      beam.interpreters.${cfg.erlangVersion}
      beam.packages.${cfg.erlangVersion}.rebar3
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ ];
  };

  options.syde.programming.gleam = {
    enable = mkEnableOption "gleam language tools";
    erlangVersion = mkOption {
      type = types.str;
      default = "erlang_25";
    };
  };
}

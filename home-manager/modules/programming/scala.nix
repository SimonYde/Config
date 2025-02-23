{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.syde.programming.scala;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      scala
      scalafmt
      metals
    ];

    programs.sbt.enable = true;

    programs.neovim.plugins = with pkgs.vimPlugins; [ ];
  };

  options.syde.programming.scala = {
    enable = mkEnableOption "scala language tooling";
  };
}

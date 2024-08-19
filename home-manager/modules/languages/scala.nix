{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.syde.programming.scala;
  java = config.syde.programming.java;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      scala
      scalafmt
      sbt
      java.jdk

      metals
    ];

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        nvim-metals
        plenary-nvim
      ];
    };
  };

  options.syde.programming = {
    scala = {
      enable = mkEnableOption "scala language tooling";
    };
  };
}

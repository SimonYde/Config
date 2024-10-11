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
      sbt
      metals
    ];

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (p: [
          p.scala
        ]))
      ];
    };
  };

  options.syde.programming = {
    scala = {
      enable = mkEnableOption "scala language tooling";
    };
  };
}

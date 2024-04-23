{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) types;
  cfg = config.syde.programming.java;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gradle
      gradle-completion
      metals
      jdt-language-server
      cfg.jdk
      (lib.mkIf cfg.enableMaven maven)
    ];

    home.sessionVariables = {
      JAVA_HOME = "${cfg.jdk}";
    };

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        nvim-jdtls
      ];
    };
  };

  options.syde.programming = {
    java = {
      enable = lib.mkEnableOption "java";
      enableMaven = lib.mkEnableOption "maven for java";

      jdk = lib.mkOption {
        type = types.package;
        default = pkgs.jdk;
      };
    };
  };
}

{ lib, pkgs, config, ... }:

let
  cfg = config.syde.programming.java;
in
{
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
    java = with lib; {
      enable = mkEnableOption "java";
      enableMaven = mkEnableOption "maven for java";

      jdk = mkOption {
        type = types.package;
        default = pkgs.jdk;
      };
    };
  };

}

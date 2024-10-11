{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    ;
  cfg = config.syde.programming.java;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gradle
      gradle-completion
      jdt-language-server
      cfg.jdk
      (mkIf cfg.enableMaven maven)
    ];

    home.sessionVariables = {
      JAVA_HOME = "${cfg.jdk}";
    };

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (p: [
          p.java
        ]))

        nvim-jdtls
      ];
    };
  };

  options.syde.programming = {
    java = {
      enable = mkEnableOption "java";
      enableMaven = mkEnableOption "maven for java";

      jdk = mkOption {
        type = types.package;
        default = pkgs.jdk;
      };
    };
  };
}

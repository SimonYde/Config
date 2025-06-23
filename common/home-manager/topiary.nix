{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    types
    mkIf
    mkPackageOption
    mkEnableOption
    mkOption
    ;
  cfg = config.programs.topiary;
in
{
  config = mkIf cfg.enable {
    home = {

      packages = [ cfg.package ];

      sessionVariables.TOPIARY_LANGUAGE_DIR = cfg.languageDir;

      file = {
        "${cfg.languageDir}/nu.scm".source = inputs.topiary-nushell + "/languages/nu.scm";
      };
    };
  };

  options.programs.topiary = {
    enable = mkEnableOption "topiary";

    package = mkPackageOption pkgs "topiary" { };

    languageDir = mkOption {
      type = types.str;
      default = "${config.xdg.configHome}/topiary/languages";
    };
  };
}

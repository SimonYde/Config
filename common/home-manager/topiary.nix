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

      sessionVariables.TOPIARY_LANGUAGE_DIR = cfg.language_dir;

      file = {
        "${cfg.language_dir}/nu.scm".source = inputs.topiary-nushell + "/languages/nu.scm";
      };
    };
  };

  options.programs.topiary = {
    enable = mkEnableOption "topiary";

    package = mkPackageOption pkgs "topiary" { };

    language_dir = mkOption {
      type = types.str;
      default = "${config.xdg.configHome}/topiary/languages";
    };
  };
}

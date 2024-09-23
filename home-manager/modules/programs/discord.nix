{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkEnableOption
    mkPackageOption
    mkIf
    ;
  cfg = config.syde.programs.discord;
in
{
  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      cfg.betterDiscordCtlPackage
    ];
  };

  options.syde.programs.discord = {
    enable = mkEnableOption "Discord";

    package = mkPackageOption pkgs "discord" { };

    betterDiscordCtlPackage = mkPackageOption pkgs "betterdiscordctl" { };
    plugins = mkOption {
      default = [ ];
      description = "Optional BetterDiscord plugins.";
      type = types.listOf types.package;
    };

  };
}

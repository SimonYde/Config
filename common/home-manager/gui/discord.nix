{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    ;
  cfg = config.programs.discord;
in
{
  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      cfg.betterDiscordCtlPackage
    ];
  };
  options.programs.discord = {
    enable = mkEnableOption "Discord";
    package = mkPackageOption pkgs "discord" { };
    betterDiscordCtlPackage = mkPackageOption pkgs "betterdiscordctl" { };
  };
}

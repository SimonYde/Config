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
      pkgs.curl
    ];
    home.activation.better-discord-install = lib.hm.dag.entryAfter [ "installPackages" ] ''
      PATH="${config.home.path}/bin:$PATH" $DRY_RUN_CMD betterdiscordctl install
    '';
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

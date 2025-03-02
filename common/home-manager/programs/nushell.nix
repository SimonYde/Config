{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  plugins = with pkgs.nushellPlugins; [
    # skim
    formats
    gstat
    query
    formats
  ];
  cfg = config.programs.nushell;
in
{
  config = mkIf cfg.enable {

    home.packages =
      with pkgs;
      [
        nufmt
        nu_scripts
      ]
      ++ plugins;

    programs.carapace.enable = true;
    services.pueue.enable = true; # Background jobs

    programs.nushell = {
      shellAliases = {
        ll = "ls -l";
        la = "ls -a";
        lla = "ls -la";
      };
      inherit plugins;
      configFile.source = ./config.nu;
    };
  };
}

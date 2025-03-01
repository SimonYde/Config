{ config, lib, ... }:

let
  cfg = config.programs.carapace;
in
{
  config = lib.mkIf cfg.enable {
    programs.carapace = {
      enableFishIntegration = false;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };
  };
}

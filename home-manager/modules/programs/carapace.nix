{ config, lib, ... }:

let
  cfg = config.programs.carapace;
in
{
  config = lib.mkIf cfg.enable {
    programs.carapace = {
      enableFishIntegration = false;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };
  };
}

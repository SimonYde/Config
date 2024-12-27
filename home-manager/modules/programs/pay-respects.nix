{ config, lib, ... }:

let
  cfg = config.programs.pay-respects;
  inherit (lib) getExe mkIf;
in
{
  config = mkIf cfg.enable {
    programs.pay-respects.enableNushellIntegration = false;
    programs.nushell = {
      extraEnv = # nu
        ''
          let pay_respects_cache = "${config.xdg.cacheHome}/pay-respects"
          if not ($pay_respects_cache | path exists) {
            mkdir $pay_respects_cache
          }
          ${getExe cfg.package} nushell --alias "f" | save -f $"($pay_respects_cache)/init.nu"
        '';
      extraConfig = # nu
        ''
          source ${config.xdg.cacheHome}/pay-respects/init.nu
        '';
    };
  };
}

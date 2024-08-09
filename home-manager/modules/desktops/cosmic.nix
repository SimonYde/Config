{lib, config, ...}:

let
  cfg = config.syde.desktop.cosmic;
in 

{
  config = lib.mkIf cfg.enable {

  };
  options.syde.desktop.cosmic = {
    enable = lib.mkEnableOption "Cosmic DE";
  };
}

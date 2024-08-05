{ config, lib, ... }:
let
  cfg = config.qt;
in
{
  config = lib.mkIf cfg.enable {
    qt = {
      platformTheme.name = lib.mkDefault "gtk3";
    };
  };
}

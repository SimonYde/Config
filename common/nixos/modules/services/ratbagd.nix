{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.ratbagd;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      piper
    ];
  };
}

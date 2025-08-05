{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mapAttrs'
    mergeAttrsList
    types
    nameValuePair
    ;

  cfg = config.syde.monitoring;
in
{
  options = {
    syde.monitoring = {
      enable = mkEnableOption "monitoring";
    };

    services.alloy = {
      configs = mkOption {
        type = types.attrsOf types.path;
      };
    };
  };

  config = mkIf cfg.enable {
    services.alloy = {
      enable = true;
      configs."config" = ./common.alloy;
    };

    systemd.services.alloy = {
      after = [
        "tailscaled.service"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
    };

    environment.etc = mergeAttrsList [
      (mapAttrs' (
        name: value: (nameValuePair ("alloy/${name}.alloy") ({ source = value; }))
      ) config.services.alloy.configs)
    ];
  };
}

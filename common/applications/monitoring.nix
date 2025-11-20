{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
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
      scrape = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              port = mkOption {
                type = types.nullOr types.port;
                example = 9000;
                default = null;
              };

              url = mkOption {
                type = types.nullOr types.str;
                example = "www.example.com";
                default = null;
              };
            };
          }
        );
      };
    };
  };

  config = mkIf cfg.enable {
    services.alloy = {
      enable = true;
    };

    systemd.services.alloy = {
      after = [
        "tailscaled.service"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
    };

    environment.etc = mkMerge [
      {
        "alloy/config.alloy".source = ./common.alloy;
      }

      (mergeAttrsList [
        (mapAttrs' (
          name: value:
          (nameValuePair "alloy/${name}.alloy" {
            text = ''
              scrape_url "${name}" {
                name = "${name}"
                url  = "${
                  if value.url != null then
                    value.url
                  else if value.port != null then
                    "localhost:${toString value.port}"
                  else
                    throw "For scraping a url, either a URL or port must be specified"
                }"
              }
            '';
          })
        ) config.services.alloy.scrape)
      ])
    ];
  };
}

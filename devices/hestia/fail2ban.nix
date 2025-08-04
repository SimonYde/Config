{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mapAttrs
    mapAttrs'
    mergeAttrsList
    types
    nameValuePair
    ;

  cfg = config.syde.services.fail2ban;
in
{
  options.syde.services.fail2ban = {
    enable = mkEnableOption "fail2ban";
    jails = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            serviceName = lib.mkOption {
              example = "vaultwarden";
              type = lib.types.str;
            };

            failRegex = lib.mkOption {
              type = lib.types.str;
              example = "Login failed from IP: <HOST>";
            };

            ignoreRegex = lib.mkOption {
              type = lib.types.str;
              default = "";
            };

            maxRetry = lib.mkOption {
              type = lib.types.int;
              default = 4;
            };

            action = mkOption {
              type = types.str;
              default = ''iptables[type=allports, name=HTTP, port="http,https"]'';
            };
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;

      # Do not consider tailnet traffic.
      ignoreIP = [ "100.64.0.0/10" ];

      jails = mapAttrs (name: value: {
        settings = {
          bantime = "30d";
          findtime = "1h";
          enabled = true;
          backend = "systemd";
          journalmatch = "_SYSTEMD_UNIT=${value.serviceName}.service";
          port = "http,https";
          filter = "${name}";
          maxretry = value.maxRetry;
          action = value.action;
        };
      }) cfg.jails;
    };

    environment.etc = mergeAttrsList [
      (mapAttrs' (
        name: value:
        (nameValuePair ("fail2ban/filter.d/${name}.conf") ({
          text = ''
            [Definition]
            failregex = ${value.failRegex}
            ignoreregex = ${value.ignoreRegex}
          '';
        }))
      ) cfg.jails)
    ];
  };
}

{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    mkForce
    mkOverride
    concatMapStringsSep
    ;
  cfg = config.services.nginx;
  nginxCfg = config.syde.nginx;
in
{
  options.syde.nginx = {
    internalNetworks = mkOption {
      type = types.listOf types.str;
      default = [
        "127.0.0.1/32"
        "::1/128"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
        "100.64.0.0/10" # Tailscale and NetBird (CGNAT range)
        "fd7a:115c:a1e0::/48" # Tailscale IPv6
        "fdfa:fe4a:6cb4:6dc1::/64" # NetBird IPv6
      ];
      description = ''
        Source networks considered internal, such as localhost, the LAN,
        Tailscale, and NetBird. Used by `internalOnly` nginx locations.
      '';
    };
  };

  options.services.nginx = {
    upstreams = mkOption {
      type = types.attrsOf (types.submodule { config.extraConfig = mkOverride 99 "keepalive 8;"; });
    };
    virtualHosts = mkOption {
      type = types.attrsOf (
        types.submodule {
          options.locations = mkOption {
            type = types.attrsOf (
              types.submodule (
                { config, ... }: {
                  options.internalOnly = mkEnableOption "restrict access to internal networks";

                  config = mkIf config.internalOnly {
                    extraConfig = ''
                      if ($syde_internal = 0) {
                        return 403;
                      }
                    '';
                  };
                }
              )
            );
          };

          # Priority slightly above normal explicit values, so it wins against service modules,
          # but still loses to mkForce
          config = mkOverride 99 {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
            kTLS = true;
            http3 = true;
            quic = true;
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    services = {
      nginx = {
        enableQuicBPF = true;

        recommendedOptimisation = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;
        recommendedBrotliSettings = true;
        recommendedProxySettings = true;

        statusPage = true;

        # give Nginx access to our certs
        group = "acme";

        appendHttpConfig = ''
          access_log syslog:server=unix:/dev/log,severity=debug;

          # Shared rule for locations marked with `internalOnly = true`.
          geo $syde_internal {
            default 0;
            ${concatMapStringsSep "\n" (network: "${network} 1;") nginxCfg.internalNetworks}
          }
        '';

        eventsConfig = ''
          worker_connections 2048;
        '';

        virtualHosts.localhost = {
          enableACME = mkForce false;
          forceSSL = mkForce false;
          listen = [
            { addr = "127.0.0.1:9002"; }
            { addr = "[::1]:9002"; }
          ];
        };

      };

      logrotate.enable = false;

      resolved.enable = true;

      prometheus.exporters.nginx = {
        inherit (config.syde.monitoring) enable;
        scrapeUri = "http://localhost:9002/nginx_status";
        port = 9004;
        sslVerify = false;
      };
    };

    services.alloy.scrape.nginx = {
      inherit (config.services.prometheus.exporters.nginx) port;
    };

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
    };

    systemd.services.nginx.serviceConfig.LimitNOFILE = "524288:524288";
  };
}

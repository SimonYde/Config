{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    mkForce
    mkOverride
    ;
  cfg = config.services.nginx;
in
{
  options.services.nginx = {
    upstreams = mkOption {
      type = types.attrsOf (types.submodule { config.extraConfig = mkOverride 99 "keepalive 8;"; });
    };
    virtualHosts = mkOption {
      type = types.attrsOf (
        types.submodule {
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

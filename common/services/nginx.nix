{ lib, config, ... }:
let
  inherit (lib)
    mkOption
    types
    mkIf
    mkForce
    ;
  cfg = config.services.nginx;
in
{
  options.services.nginx = {
    upstreams = mkOption {
      type = types.attrsOf (types.submodule { config.extraConfig = lib.mkOverride 99 "keepalive 8;"; });
    };
    virtualHosts = mkOption {
      type = types.attrsOf (
        types.submodule {
          # Priority slightly above normal explicit values, so it wins against service modules,
          # but still loses to mkForce
          config = lib.mkOverride 99 {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
            kTLS = true;
            http3 = true;
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    services = {
      nginx = {
        recommendedOptimisation = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;
        recommendedBrotliSettings = true;
        recommendedProxySettings = true;

        resolver.addresses = [ "127.0.0.53" ];

        statusPage = true;

        # give Nginx access to our certs
        group = "acme";

        appendConfig = ''
          worker_processes auto;
        '';

        appendHttpConfig = ''
          access_log syslog:server=unix:/dev/log,severity=debug;
        '';

        eventsConfig = ''
          worker_connections 2048;
        '';

        # Required for QUIC with workers
        virtualHosts.localhost = {
          reuseport = true;
          enableACME = mkForce false;
          forceSSL = mkForce false;
        };

      };

      logrotate.enable = false;

      resolved.enable = true;

      prometheus.exporters.nginx = {
        enable = true;
        port = 9004;
        sslVerify = false;
      };
    };

    environment.etc."alloy/nginx.alloy".text = ''
      scrape_url "nginx" {
        name = "nginx"
        url  = "localhost:9004"
      }
    '';

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
    };
  };
}

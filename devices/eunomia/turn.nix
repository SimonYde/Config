{ config, lib, inputs, ... }:
let
  inherit (lib) mkOption types;
  inherit (config.syde) server;

  inherit (server) addrs turn;

  certsDirectory = config.security.acme.certs.${turn.url}.directory;
in
{
  options.syde.server.turn = {
    url = mkOption {
      type = types.str;
      description = ''
        URL where TURN server should be running.
      '';
      default = "${config.networking.hostName}.${server.baseDomain}";
    };
  };
  config = {

    age.secrets.turnSecretFile.file = "${inputs.secrets}/turnSecretFile.age";

    security.acme.certs.${turn.url} = { };

    services.turn-rs = {
      enable = true;

      secretFile = config.age.secrets.turnSecretFile.path;

      settings = {
        server = {
          realm = server.baseDomain;
          interfaces = [
            {
              listen = "${addrs.v4}:3478";
              transport = "tcp";
              external = "${addrs.v4}:3478";
            }
            {
              listen = "${addrs.v4}:3478";
              transport = "udp";
              external = "${addrs.v4}:3478";
            }
            {
              listen = "${addrs.v4}:5349";
              transport = "tcp";
              ssl = {
                private-key = "${certsDirectory}/key.pem";
                certificate-chain = "${certsDirectory}/fullchain.pem";
              };
              external = "${addrs.v4}:5349";
            }
            {
              listen = "[${addrs.v6}]:3478";
              transport = "tcp";
              external = "[${addrs.v6}]:3478";
            }
            {
              listen = "[${addrs.v6}]:3478";
              transport = "udp";
              external = "[${addrs.v6}]:3478";
            }
            {
              listen = "[${addrs.v6}]:5349";
              transport = "tcp";
              ssl = {
                private-key = "${certsDirectory}/key.pem";
                certificate-chain = "${certsDirectory}/fullchain.pem";
              };
              external = "[${addrs.v6}]:5349";
            }
          ];
        };
        auth.static-credentials = {
          netbird = "$NETBIRD_PASSWORD";
        };
        prometheus.listen = "127.0.0.1:9091";
      };
    };

    services.alloy.scrape.turn_rs.port = 9091;

    systemd.services.turn-rs = {
      after = [
        "network-online.target"
        "acme-${turn.url}.service"
      ];
      wants = [ "network-online.target" ];
      serviceConfig.SupplementaryGroups = [ "acme" ];
    };

    networking.firewall = {
      allowedTCPPorts = [
        3478
        5349
      ];
      allowedUDPPorts = [ 3478 ];
      allowedUDPPortRanges = [
        {
          from = 49152;
          to = 65535;
        }
      ];
    };
  };
}

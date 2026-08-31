{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (config.syde) server;
  turn_url = server.turn.url;

  certsDirectory = config.security.acme.certs."${turn_url}".directory;
in
{
  age.secrets."netbird/relay-environment".file = "${inputs.secrets}/netbird/relay-environment.age";

  services.alloy.scrape.netbird_relay.port = 9192;

  systemd.services.netbird-relay = {
    after = [
      "network.target"
      "acme-${turn_url}.service"
    ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      NB_LISTEN_ADDRESS = "[::]:4443";
      NB_EXPOSED_ADDRESS = "rels://${turn_url}:4443";
      NB_ENABLE_STUN = "0";
      NB_TLS_CERT_FILE = "${certsDirectory}/fullchain.pem";
      NB_TLS_KEY_FILE = "${certsDirectory}/key.pem";
      NB_METRICS_PORT = "9192";
    };

    serviceConfig = {
      ExecStart = lib.getExe pkgs.netbird-relay;
      EnvironmentFile = "/run/agenix/netbird/relay-environment";

      # hardening
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = true;
      RemoveIPC = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 4443 ];
    allowedUDPPorts = [ 4443 ];
  };
}

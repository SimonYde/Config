{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce mkIf;
  inherit (config.syde) server;
  cfg = config.services.adguardhome;
in
{
  config = mkIf cfg.enable {
    age.secrets.adguardExporterEnv.file = "${inputs.secrets}/adguardExporterEnv.age";

    networking.interfaces.lo.ipv4.addresses = [
      {
        address = "127.0.0.1";
        prefixLength = 8;
      } # default loopback
      {
        address = "127.0.0.2";
        prefixLength = 8;
      } # AGH's dedicated loopback
    ];

    services = {
      adguardhome = {
        host = "127.0.0.2";
        port = 9433;
        settings = {
          dns = {
            port = 53;
            bind_hosts = [
              "127.0.0.2"
              "192.168.1.200" # LAN IP
            ];
            upstream_dns = [
              "tls://9.9.9.9"
              "tls://149.112.112.112"
            ];
            fallback_dns = mkForce [ ];
          };
          filtering = {
            protection_enabled = true;
            filtering_enabled = true;

            parental_enabled = false; # Parental control-based DNS requests filtering.
            safe_search = {
              enabled = false; # Enforcing "Safe search" option for search engines, when possible.
            };
          };
          filters =
            map
              (url: {
                enabled = true;
                url = url;
              })
              [
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
                "https://raw.githubusercontent.com/blocklistproject/Lists/refs/heads/master/smart-tv.txt" # smart tv telemetry
                "https://pgl.yoyo.org/adservers/serverlist.php?showintro=0;hostformat=hosts" # Peter Lowe’s Ad and tracking server list
                "https://easylist.to/easylist/easylist.txt"
                "https://easylist.to/easylist/easyprivacy.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/native.apple.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/native.winoffice.txt"
              ];
        };
      };

      resolved.settings.Resolve = {
        # Forward all queries to AdGuard Home
        DNS = [ "127.0.0.2" ];
        FallbackDNS = lib.mkForce [ "" ];

        # Route ALL queries through this upstream (catch-all routing domain)
        # Without ~. resolved may prefer per-link DHCP nameservers instead
        Domains = [ "~." ];

        DNSStubListener = "yes";
        DNSSEC = false;
      };

      alloy.scrape.adguard.port = 9618;

      nginx = {
        upstreams.adguard.servers."127.0.0.2:9433" = { };

        virtualHosts."adguard.i.${server.baseDomain}".locations."/" = {
          proxyPass = "http://adguard";
          proxyWebsockets = true;
        };
      };

    };

    networking.firewall = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };

    systemd.services.prometheus-adguard-exporter = {
      description = "Prometheus exporter for AdGuard Home";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "adguardhome.service"
      ];
      wants = [ "network-online.target" ];

      environment.BIND_ADDR = "127.0.0.1:9618";

      serviceConfig = {
        EnvironmentFile = config.age.secrets.adguardExporterEnv.path;
        ExecStart = lib.getExe pkgs.adguard-exporter;
        Restart = "on-failure";
        RestartSec = "5s";

        DynamicUser = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
      };
    };
  };
}

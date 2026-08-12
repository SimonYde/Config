{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (config.syde) server;
  cfg = config.services.adguardhome;
in
{
  config = mkIf cfg.enable {
    services = {
      adguardhome = {
        host = "127.0.0.1";
        port = 9433;
        settings = {
          dns = {
            upstream_dns = [
              "tls://dns.quad9.net"
            ];
            fallback_dns = lib.mkForce [
              # "9.9.9.9"
              # "149.112.112.112"
            ];
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

      resolved.settings.Resolve.DNSStubListener = false;

      nginx = {
        upstreams.adguard.servers."127.0.0.1:9433" = { };

        virtualHosts."adguard.ts.${server.baseDomain}".locations."/" = {
          proxyPass = "http://adguard";
          proxyWebsockets = true;
        };
      };

    };

    networking.firewall = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };
  };
}

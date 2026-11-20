{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.netbird.proxy;
  inherit (config.syde) server;

  # The private cluster stays on i.simonyde.com. The public cluster uses the
  # bare apex so services are <service>.simonyde.com, while nginx keeps the
  # names it manages itself (auth, dex, nb, ts, ...).
  publicProxyDomain = server.baseDomain;
  publicProxyAddress = "127.0.0.1:8844";
  publicCert = config.security.acme.certs."${publicProxyDomain}";

  # nginx terminates TLS for its own vhosts on this loopback port. The
  # public 443 listener belongs to the stream SNI router.
  nginxHttpsPort = 10443;

  # Every vhost managed by nginx keeps terminating TLS itself. Any SNI not
  # in this list is passed through to the public NetBird proxy.
  nginxDomains = builtins.filter (
    name:
    !builtins.elem name [
      "default"
      "localhost"
    ]
  ) (builtins.attrNames config.services.nginx.virtualHosts);
in
{
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.hasPrefix "127.0.0.1:" cfg.address || lib.hasPrefix "[::1]:" cfg.address;
        message = "tls-passthrough.nix requires services.netbird.proxy.address to be a loopback host:port";
      }
    ];

    # Public wildcard certificate for the bare apex. The private proxy keeps
    # its separate *.i.simonyde.com certificate.
    security.acme.certs."${publicProxyDomain}" = {
      extraDomainNames = [ "*.${publicProxyDomain}" ];
    };

    users.groups.netbird-proxy-public = { };
    users.users.netbird-proxy-public = {
      isSystemUser = true;
      group = "netbird-proxy-public";
    };

    services = {
      alloy.scrape.netbird_proxy_public.port = 9194;

      nginx = {
        # nginx no longer owns 443 directly. Its HTTPS listeners move to
        # loopback and expect the PROXY protocol from the stream router.
        defaultListen = [
          {
            addr = "127.0.0.1";
            port = nginxHttpsPort;
            ssl = true;
            proxyProtocol = true;
          }
          {
            addr = "[::1]";
            port = nginxHttpsPort;
            ssl = true;
            proxyProtocol = true;
          }
          {
            addr = "0.0.0.0";
            port = 80;
            ssl = false;
          }
          {
            addr = "[::]";
            port = 80;
            ssl = false;
          }
        ];

        # Preserve the original client address through the stream router.
        # Without this, every request would appear to come from 127.0.0.1 and
        # internalOnly locations would allow everything.
        appendHttpConfig = ''
          set_real_ip_from 127.0.0.1;
          set_real_ip_from ::1;
          real_ip_header proxy_protocol;
        '';

        # Public TLS entry point. SNI routing:
        #   - known nginx vhosts (auth, dex, nb, ts, ...) -> nginx
        #   - everything else -> public NetBird proxy
        #
        # Public NetBird services need a DNS-only *.simonyde.com record
        # pointing at this host. Private services stay on *.i.simonyde.com
        # and use NetBird's private DNS, so they need no public record.
        #
        # UDP 443 is forwarded to nginx so its QUIC listeners remain usable.
        streamConfig = ''
          map $ssl_preread_server_name $syde_tls_upstream {
            hostnames;
            default ${publicProxyAddress};
          ${lib.concatMapStringsSep "\n" (
            domain: "  ${domain} 127.0.0.1:${toString nginxHttpsPort};"
          ) nginxDomains}
          }

          server {
            listen 443;
            listen [::]:443;
            ssl_preread on;
            proxy_protocol on;
            proxy_pass $syde_tls_upstream;
          }

          server {
            listen 443 udp;
            listen [::]:443 udp;
            proxy_pass 127.0.0.1:${toString nginxHttpsPort};
          }
        '';
      };
    };

    # Public cluster: <service>.simonyde.com. It is deliberately not a
    # private cluster, so NetBird-Only services cannot be created here.
    #
    # services.netbird.proxy is a singleton module, so this is a second
    # proxy instance. It shares the management-wide proxy token with the
    # private instance; if that token is ever made cluster-scoped, give this
    # unit its own environmentFile instead.
    systemd.services.netbird-proxy-public = {
      description = "NetBird public reverse proxy";
      documentation = [ "https://docs.netbird.io/manage/reverse-proxy" ];

      after = [
        "network-online.target"
        "netbird-management.service"
        "acme-${publicProxyDomain}.service"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        NB_PROXY_DOMAIN = publicProxyDomain;
        NB_PROXY_ADDRESS = publicProxyAddress;
        NB_PROXY_PRIVATE = "false";
        NB_PROXY_REQUIRE_SUBDOMAIN = "true";

        # Same-host management connection; avoids exposing the ProxyService
        # gRPC route through nginx.
        NB_PROXY_MANAGEMENT_ADDRESS = "http://127.0.0.1:${toString config.services.netbird.server.management.port}";
        NB_PROXY_ALLOW_INSECURE = "true";

        # nginx is the public L4 edge and sends a PROXY protocol header so
        # the proxy sees the original client address.
        NB_PROXY_PROXY_PROTOCOL = "true";
        NB_PROXY_TRUSTED_PROXIES = "127.0.0.1/32,::1/128";

        # Static wildcard certificate, renewed by the system ACME service.
        NB_PROXY_ACME_CERTIFICATES = "false";
        NB_PROXY_CERTIFICATE_DIRECTORY = publicCert.directory;
        NB_PROXY_CERTIFICATE_FILE = "fullchain.pem";
        NB_PROXY_CERTIFICATE_KEY_FILE = "key.pem";

        NB_PROXY_HEALTH_ADDRESS = "127.0.0.1:9194";
        NB_PROXY_GEO_DATA_DIR = "/var/lib/netbird-proxy-public/geolocation";
        NB_PROXY_LOG_LEVEL = "info";
      };

      serviceConfig = {
        ExecStart = lib.getExe pkgs.netbird-proxy;
        EnvironmentFile = config.age.secrets."netbird/proxy-environment".path;

        User = "netbird-proxy-public";
        Group = "netbird-proxy-public";
        SupplementaryGroups = [ "acme" ];

        StateDirectory = "netbird-proxy-public";
        StateDirectoryMode = "0750";
        WorkingDirectory = "/var/lib/netbird-proxy-public";
        UMask = "0077";

        Restart = "always";
        RestartSec = "5s";

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
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };
  };
}

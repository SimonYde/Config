{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    boolToString
    getExe
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalAttrs
    optionalString
    ;
  inherit (lib.types)
    attrsOf
    bool
    enum
    externalPath
    ints
    listOf
    nullOr
    port
    str
    ;

  cfg = config.services.netbird.proxy;

  stateDir = "/var/lib/netbird-proxy";
  certificateDirectory =
    if cfg.certificateDirectory != null then cfg.certificateDirectory else "${stateDir}/certs";
  geoDataDir = if cfg.geoDataDir != null then cfg.geoDataDir else "${stateDir}/geolocation";

  listenPort =
    address:
    let
      match = builtins.match ".*:([0-9]+)$" address;
    in
    if match == null then null else lib.toInt (builtins.head match);

  needsPrivilegedPort = lib.any (port: port != null && port < 1024) (
    [ (listenPort cfg.address) ] ++ lib.optional cfg.acme.enable (listenPort cfg.acme.address)
  );

  # The proxy has no configuration file; every flag also has an environment
  # variable equivalent. Keeping these in `environment` means `systemctl show`
  # and `systemctl cat` expose the effective configuration.
  environment = {
    NB_PROXY_DOMAIN = cfg.domain;
    NB_PROXY_ADDRESS = cfg.address;
    NB_PROXY_MANAGEMENT_ADDRESS = cfg.managementAddress;
    NB_PROXY_ALLOW_INSECURE = boolToString cfg.allowInsecure;
    NB_PROXY_PRIVATE = boolToString cfg.private;
    NB_PROXY_REQUIRE_SUBDOMAIN = boolToString cfg.requireSubdomain;
    NB_PROXY_SUPPORTS_CUSTOM_PORTS = boolToString cfg.supportsCustomPorts;
    NB_PROXY_PROXY_PROTOCOL = boolToString cfg.proxyProtocol;
    NB_PROXY_WG_PORT = toString cfg.wireguardPort;
    NB_PROXY_EXTERNAL_IP_MAP = lib.concatStringsSep "," cfg.externalIPMap;
    NB_PROXY_FORWARDED_PROTO = cfg.forwardedProto;
    NB_PROXY_TRUSTED_PROXIES = lib.concatStringsSep "," cfg.trustedProxies;

    NB_PROXY_HEALTH_ADDRESS = cfg.healthAddress;
    NB_PROXY_GEO_DATA_DIR = geoDataDir;
    NB_PROXY_LOG_LEVEL = cfg.logLevel;
    NB_PROXY_DEBUG_LOGS = boolToString cfg.debugLogs;
    NB_PROXY_DEBUG_ENDPOINT = boolToString cfg.debugEndpoint;
    NB_PROXY_DEBUG_ENDPOINT_ADDRESS = cfg.debugEndpointAddress;

    NB_PROXY_ACME_CERTIFICATES = boolToString cfg.acme.enable;
    NB_PROXY_ACME_ADDRESS = cfg.acme.address;
    NB_PROXY_ACME_DIRECTORY = cfg.acme.directory;
    NB_PROXY_ACME_CHALLENGE_TYPE = cfg.acme.challengeType;
    NB_PROXY_CERTIFICATE_DIRECTORY = certificateDirectory;
    NB_PROXY_CERTIFICATE_FILE = cfg.certificateFile;
    NB_PROXY_CERTIFICATE_KEY_FILE = cfg.certificateKeyFile;
    NB_PROXY_CERT_LOCK_METHOD = cfg.certificateLockMethod;
  }
  // optionalAttrs (cfg.wildcardCertificateDirectory != null) {
    NB_PROXY_WILDCARD_CERT_DIR = cfg.wildcardCertificateDirectory;
  }
  // optionalAttrs (cfg.maxDialTimeout != null) {
    NB_PROXY_MAX_DIAL_TIMEOUT = cfg.maxDialTimeout;
  }
  // optionalAttrs (cfg.maxSessionIdleTimeout != null) {
    NB_PROXY_MAX_SESSION_IDLE_TIMEOUT = cfg.maxSessionIdleTimeout;
  }
  // optionalAttrs (cfg.mappingBatchWatchdog != null) {
    NB_PROXY_MAPPING_BATCH_WATCHDOG = cfg.mappingBatchWatchdog;
  }
  // optionalAttrs (cfg.preallocatedBuffers != null) {
    NB_PROXY_PREALLOCATED_BUFFERS = toString cfg.preallocatedBuffers;
  }
  // optionalAttrs (cfg.maxBatchSize != null) {
    NB_PROXY_MAX_BATCH_SIZE = toString cfg.maxBatchSize;
  }
  // cfg.extraEnvironment;
in
{
  options.services.netbird.proxy = {
    enable = mkEnableOption "NetBird reverse proxy";

    package = mkPackageOption pkgs "netbird-proxy" { };

    domain = mkOption {
      type = str;
      description = ''
        The domain at which this proxy is reachable. Self-hosted services are
        exposed as `{subdomain}.{domain}` unless `requireSubdomain` is disabled.
      '';
      example = "proxy.example.com";
    };

    address = mkOption {
      type = str;
      default = ":443";
      description = ''
        Address the reverse proxy listens on. The main listener handles HTTP
        and TLS services; L4 services open additional ports through it.
      '';
      example = "127.0.0.1:8443";
    };

    managementAddress = mkOption {
      type = str;
      default = "https://api.netbird.io:443";
      description = ''
        Address of the NetBird management server this proxy connects to.
      '';
      example = "https://netbird.example.com:443";
    };

    allowInsecure = mkOption {
      type = bool;
      default = false;
      description = ''
        Allow sending the proxy token over a non-TLS management connection.
        Only enable this when connecting to management over loopback or a
        trusted private network.
      '';
    };

    private = mkOption {
      type = bool;
      default = false;
      description = ''
        Advertise the private/NetBird-only service capability. Services on this
        proxy can then use NetBird-Only access instead of public authentication.
      '';
    };

    requireSubdomain = mkOption {
      type = bool;
      default = false;
      description = ''
        Require a subdomain label in front of `domain` for service domains.
      '';
    };

    supportsCustomPorts = mkOption {
      type = bool;
      default = true;
      description = ''
        Whether the proxy may bind arbitrary ports for TCP and UDP services.
      '';
    };

    proxyProtocol = mkOption {
      type = bool;
      default = false;
      description = ''
        Send a PROXY protocol v2 header to TCP and TLS backends so they can see
        the original client address.
      '';
    };

    wireguardPort = mkOption {
      type = port;
      default = 0;
      description = ''
        WireGuard listen port for proxy tunnels. `0` selects a random port; a
        fixed port is only supported for single-account deployments.
      '';
    };

    externalIPMap = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        External addresses to advertise as ICE candidates, as `IP` or
        `IP/internal-IP-or-interface`. Requires a fixed `wireguardPort` forwarded
        through NAT.
      '';
      example = [ "203.0.113.5/10.0.0.5" ];
    };

    forwardedProto = mkOption {
      type = enum [
        "auto"
        "http"
        "https"
      ];
      default = "auto";
      description = ''
        Value used for the `X-Forwarded-Proto` header sent to backends.
      '';
    };

    trustedProxies = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Upstream proxy CIDR ranges whose forwarded headers are trusted.
      '';
      example = [
        "10.0.0.0/8"
        "192.168.1.1"
      ];
    };

    healthAddress = mkOption {
      type = str;
      default = "localhost:8080";
      description = "Address for the liveness/readiness/startup health endpoint.";
    };

    geoDataDir = mkOption {
      type = nullOr str;
      default = null;
      defaultText = literalExpression ''"${stateDir}/geolocation"'';
      description = ''
        Directory containing the GeoLite2 database used for country-based
        access restrictions. The database is downloaded automatically when it
        is missing.
      '';
    };

    logLevel = mkOption {
      type = enum [
        "panic"
        "fatal"
        "error"
        "warn"
        "warning"
        "info"
        "debug"
        "trace"
      ];
      default = "info";
      description = "Log level of the NetBird proxy.";
    };

    debugLogs = mkOption {
      type = bool;
      default = false;
      description = "Enable debug logging. Deprecated upstream in favour of `logLevel = \"debug\"`.";
    };

    debugEndpoint = mkOption {
      type = bool;
      default = false;
      description = "Enable the debug HTTP endpoint.";
    };

    debugEndpointAddress = mkOption {
      type = str;
      default = "localhost:8444";
      description = "Address for the debug HTTP endpoint.";
    };

    maxDialTimeout = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Cap for per-service backend dial timeouts, as a Go duration string.
        `null` keeps the upstream default (no cap).
      '';
      example = "30s";
    };

    maxSessionIdleTimeout = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Cap for per-service UDP session idle timeouts, as a Go duration string.
        `null` keeps the upstream default (no cap).
      '';
      example = "2m";
    };

    mappingBatchWatchdog = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Watchdog timeout for mapping batches, as a Go duration string.
        `null` keeps the upstream default.
      '';
      example = "30s";
    };

    preallocatedBuffers = mkOption {
      type = nullOr ints.unsigned;
      default = null;
      description = ''
        Cap on the per-tunnel buffer pool. `null` keeps the upstream default
        (uncapped).
      '';
    };

    maxBatchSize = mkOption {
      type = nullOr ints.unsigned;
      default = null;
      description = ''
        Override for the per-tunnel batch size. `null` keeps the platform
        default.
      '';
    };

    environmentFile = mkOption {
      type = nullOr externalPath;
      default = null;
      description = ''
        Environment file containing `NB_PROXY_TOKEN` and any other secrets.
        Either this or {option}`tokenFile` is required.
      '';
      example = "/run/secrets/netbird-proxy.env";
    };

    tokenFile = mkOption {
      type = nullOr externalPath;
      default = null;
      description = ''
        File containing only the proxy access token. It is loaded as a systemd
        credential instead of being placed in the environment file. Either this
        or {option}`environmentFile` is required.
      '';
      example = "/run/secrets/netbird-proxy-token";
    };

    certificateDirectory = mkOption {
      type = nullOr str;
      default = null;
      defaultText = literalExpression ''"${stateDir}/certs"'';
      description = ''
        Directory containing TLS certificates. For static certificate mode it
        must contain {option}`certificateFile` and {option}`certificateKeyFile`.
      '';
    };

    certificateFile = mkOption {
      type = str;
      default = "tls.crt";
      description = "Certificate filename within {option}`certificateDirectory`.";
    };

    certificateKeyFile = mkOption {
      type = str;
      default = "tls.key";
      description = "Private key filename within {option}`certificateDirectory`.";
    };

    certificateLockMethod = mkOption {
      type = enum [
        "auto"
        "flock"
        "k8s-lease"
      ];
      default = "auto";
      description = "Certificate lock method used to coordinate multiple proxy replicas.";
    };

    wildcardCertificateDirectory = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Directory containing wildcard certificate/key pairs. When set, matching
        wildcard certificates bypass ACME certificate provisioning.
      '';
    };

    acme = {
      enable = mkEnableOption "automatic ACME certificate provisioning";

      address = mkOption {
        type = str;
        default = ":80";
        description = "Address used for HTTP-01 ACME challenges.";
      };

      directory = mkOption {
        type = str;
        default = "https://acme-v02.api.letsencrypt.org/directory";
        description = "URL of the ACME directory to use.";
      };

      challengeType = mkOption {
        type = enum [
          "tls-alpn-01"
          "http-01"
        ];
        default = "tls-alpn-01";
        description = ''
          ACME challenge type. `tls-alpn-01` uses port 443 and works through
          TLS passthrough; `http-01` uses port 80.
        '';
      };
    };

    supplementaryGroups = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Additional groups for the proxy user. This is useful when reading
        certificates from a directory owned by another group, such as the NixOS
        ACME `acme` group.
      '';
      example = [ "acme" ];
    };

    extraEnvironment = mkOption {
      type = attrsOf str;
      default = { };
      description = ''
        Additional environment variables for the proxy. Values here override
        the options above, which makes it possible to use upstream settings
        that do not have a dedicated NixOS option yet.

        These values are visible in the Nix store and the generated unit, so do
        not put secrets here. Use {option}`environmentFile` for those.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.tokenFile != null || cfg.environmentFile != null;
        message = "services.netbird.proxy requires either tokenFile or environmentFile";
      }
      {
        assertion = cfg.address != cfg.healthAddress;
        message = "services.netbird.proxy: address and healthAddress cannot be the same";
      }
    ];

    users.groups.netbird-proxy = { };
    users.users.netbird-proxy = {
      isSystemUser = true;
      group = "netbird-proxy";
    };

    systemd.services.netbird-proxy = {
      description = "NetBird reverse proxy";
      documentation = [ "https://docs.netbird.io/manage/reverse-proxy" ];

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      inherit environment;

      script = ''
        ${optionalString (cfg.tokenFile != null) ''
          export NB_PROXY_TOKEN="$(< "$CREDENTIALS_DIRECTORY/proxy-token")"
        ''}
        exec ${getExe cfg.package}
      '';

      serviceConfig = {
        EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
        LoadCredential = optional (cfg.tokenFile != null) "proxy-token:${cfg.tokenFile}";

        User = "netbird-proxy";
        Group = "netbird-proxy";
        SupplementaryGroups = cfg.supplementaryGroups;

        StateDirectory = "netbird-proxy";
        StateDirectoryMode = "0750";
        WorkingDirectory = stateDir;
        ReadWritePaths =
          optional (cfg.acme.enable && cfg.certificateDirectory != null) certificateDirectory
          ++ optional (cfg.geoDataDir != null) cfg.geoDataDir;

        Restart = "always";
        RestartSec = "5s";

        # Allow binding 80/443 without running the whole service as root.
        CapabilityBoundingSet = optional needsPrivilegedPort "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = optional needsPrivilegedPort "CAP_NET_BIND_SERVICE";

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
        UMask = "0077";
      };
    };
  };
}

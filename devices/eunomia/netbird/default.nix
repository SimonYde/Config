{ inputs, config, ... }:

let
  inherit (config.syde) server;

  inherit (config.networking) hostName;

  host_url = "${hostName}.${server.baseDomain}";

  mkStun = host: {
    Proto = "udp";
    URI = "stun:${host}:3478";
    Username = "netbird";
    Password._secret = "/run/agenix/netbird/turn-password";
  };

  mkTurn = host: {
    Proto = "udp";
    URI = "turn:${host}:3478";
    Username = "netbird";
    Password._secret = "/run/agenix/netbird/turn-password";
  };
in
{
  imports = [ ./netbird-relay.nix ];

  age.secrets = {
    "netbird/data-store-encryption-key".file =
      "${inputs.secrets}/netbird/data-store-encryption-key.age";
    "netbird/relay-secret".file = "${inputs.secrets}/netbird/relay-secret.age";
    "netbird/turn-password".file = "${inputs.secrets}/netbird/turn-password.age";
  };

  services = {
    netbird.server = {
      enable = true;
      enableNginx = true;
      domain = "nb.${server.baseDomain}";

      management = {
        metricsPort = 9190;
        turnDomain = "not-real.${server.baseDomain}";
        dnsDomain = "nodes.nb.${server.baseDomain}";
        oidcConfigEndpoint = "https://${server.authDomain}/oauth2/openid/netbird/.well-known/openid-configuration";

        settings = {
          DataStoreEncryptionKey._secret = "/run/agenix/netbird/data-store-encryption-key";
          Stuns = map mkStun [ host_url ];
          TURNConfig = {
            Secret._secret = "/run/agenix/netbird/relay-secret";
            Turns = map mkTurn [ host_url ];
            CredentialsTTL = "12h";
          };
          Relay = {
            Addresses = [
              "rels://${host_url}:4443"
            ];
            Secret._secret = "/run/agenix/netbird/relay-secret";
            CredentialsTTL = "12h";
          };
          StoreConfig.Engine = "postgres";
          DeviceAuthorizationFlow.ProviderConfig.Scope = "openid profile email groups_name";
          PKCEAuthorizationFlow.ProviderConfig = {
            AuthorizationEndpoint = "https://${server.authDomain}/ui/oauth2";
            TokenEndpoint = "https://${server.authDomain}/oauth2/token";
            Scope = "openid profile email groups_name";
            UseIDToken = true;
          };
        };
      };

      signal.metricsPort = 9191;

      dashboard.settings = {
        AUTH_AUTHORITY = "https://${server.authDomain}/oauth2/openid/netbird/";
        AUTH_REDIRECT_URI = "/oauth2/callback";
        AUTH_SILENT_REDIRECT_URI = "/oauth2/callback/silent";
        AUTH_SUPPORTED_SCOPES = "openid profile email groups_name";
      };
    };

    postgresql = {
      enable = true;
      authentication = "local netbird netbird peer map=allow-root-netbird";
      identMap = "allow-root-netbird root netbird";

      ensureDatabases = [ "netbird" ];
      ensureUsers = [
        {
          name = "netbird";
          ensureDBOwnership = true;
        }
      ];
    };

    alloy.scrape = {
      netbird_management.port = 9190;
      netbird_signal.port = 9191;
    };
  };

  systemd.services.netbird-management = rec {
    after = [
      "network-online.target"
      "nginx.service"
      "kanidm.service"
    ];
    wants = after;
    environment = {
      NETBIRD_STORE_ENGINE_POSTGRES_DSN = "postgres:///netbird?user=netbird&host=/run/postgresql";
    };
  };
}

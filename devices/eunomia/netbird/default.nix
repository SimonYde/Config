{ inputs, config, ... }:

let
  inherit (config.syde) server;

  host_url = "${config.networking.hostName}.${server.baseDomain}";

  mkProto = proto: host: {
    Proto = "udp";
    URI = "${proto}:${host}:3478";
    Username = "netbird";
    Password._secret = "/run/agenix/netbird/turn-password";
  };

  mkStun = mkProto "stun";
  mkTurn = mkProto "turn";
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
        oidcConfigEndpoint = "https://dex.${server.baseDomain}/.well-known/openid-configuration";

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

          # Dex is the IdP facade; Kanidm is reached through its OIDC connector.
          # "hosted" is the generic RFC 8628 device flow implementation, not
          # NetBird Cloud.
          DeviceAuthorizationFlow = {
            Provider = "hosted";
            ProviderConfig = {
              Scope = "openid profile email groups";
              UseIDToken = true;
            };
          };

          # Endpoints are filled in from Dex's discovery document.
          PKCEAuthorizationFlow.ProviderConfig = {
            Scope = "openid profile email groups";
            UseIDToken = true;
          };
        };
      };

      signal.metricsPort = 9191;

      dashboard.settings = {
        AUTH_AUTHORITY = "https://dex.${server.baseDomain}";
        AUTH_REDIRECT_URI = "/oauth2/callback";
        AUTH_SILENT_REDIRECT_URI = "/oauth2/callback/silent";
        AUTH_SUPPORTED_SCOPES = "openid profile email groups";
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

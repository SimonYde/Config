{
  config,
  inputs,
  ...
}:
let
  inherit (config.syde) server;

  dexDomain = "dex.${server.baseDomain}";
  kanidmClientId = "dexidp";
in
{
  # Kanidm side (run manually):
  #   kanidm system oauth2 create dexidp "NetBird SSO broker" https://dex.simonyde.com;
  #   kanidm system oauth2 add-redirect-url dexidp https://dex.simonyde.com/callback;
  #   kanidm system oauth2 update-scope-map dexidp netbird_users openid email profile groups_name offline_access;
  #   kanidm system oauth2 update-scope-map dexidp netbird_admins openid email profile groups_name offline_access;
  #   kanidm system oauth2 show-basic-secret dexidp
  #
  # Store the result in the agenix secret as an environment-file line:
  #   KANIDM_DEX_CLIENT_SECRET=<basic secret>
  age.secrets."dex/environment".file = "${inputs.secrets}/dexClientSecret.age";

  # netbird/default.nix points its management and dashboard at this issuer.

  services = {
    dex = {
      enable = true;
      environmentFile = config.age.secrets."dex/environment".path;

      settings = {
        issuer = "https://${dexDomain}";

        storage = {
          type = "sqlite3";
          config.file = "/var/lib/dex/dex.db";
        };

        web = {
          http = "127.0.0.1:5556";

          # The NetBird dashboard is a browser SPA: its OIDC client fetches
          # discovery, JWKS and the token endpoint cross-origin.
          allowedOrigins = [ "https://nb.${server.baseDomain}" ];
          allowedHeaders = [
            "Authorization"
            "Content-Type"
          ];
        };

        oauth2.skipApprovalScreen = true;

        signer = {
          type = "local";
          config.keysRotationPeriod = "6h";
        };

        expiry = {
          idTokens = "24h";
          authRequests = "24h";
          deviceRequests = "5m";
        };

        # NetBird uses one public client for every flow. The tvOS/Android TV
        # device flow needs /device/callback (Dex's fixed device callback path),
        # and NetBird does not send a client secret, so the client must be public.
        staticClients = [
          {
            id = "netbird";
            name = "NetBird";
            public = true;
            redirectURIs = [
              "/device/callback"
              "http://localhost:53000"
              "http://localhost:53000/"
              "https://nb.${server.baseDomain}/oauth2/callback"
              "https://nb.${server.baseDomain}/oauth2/callback/silent"
            ];
          }
        ];

        connectors = [
          {
            type = "oidc";
            id = "kanidm";
            name = "Kanidm";
            config = {
              issuer = "https://${server.authDomain}/oauth2/openid/${kanidmClientId}";
              clientID = kanidmClientId;
              clientSecret = "$KANIDM_DEX_CLIENT_SECRET";
              redirectURI = "https://${dexDomain}/callback";
              # Dex always adds "openid" itself; listing it here would send it twice.
              scopes = [
                "profile"
                "email"
                "groups_name"
              ];
              # Kanidm returns group names in the "groups" claim when the
              # groups_name scope is granted.
              insecureEnableGroups = true;
              getUserInfo = true;
            };
          }
        ];
      };
    };

    nginx = {
      upstreams.dex.servers."127.0.0.1:5556" = { };

      virtualHosts.${dexDomain}.locations."/" = {
        proxyPass = "http://dex";
        proxyWebsockets = true;
      };
    };
  };

  systemd.services.dex = {
    after = [ "kanidm.service" ];
    wants = [ "kanidm.service" ];

    serviceConfig = {
      StateDirectory = "dex";
      StateDirectoryMode = "0700";
    };
  };
}

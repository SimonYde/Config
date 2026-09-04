{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.syde) server;
  cfg = config.services.qbittorrent;
in
{
  config = mkIf cfg.enable {
    age.secrets."qui/environment" = {
      file = "${inputs.secrets}/qui/environment.age";
      owner = server.user;
    };
    age.secrets."qui/session-secret" = {
      file = "${inputs.secrets}/qui/session-secret.age";
      owner = server.user;
    };

    services = {
      qbittorrent = {
        webuiPort = 8082;
        extraArgs = [ "--confirm-legal-notice" ];
        inherit (server) user group;

        serverConfig = {
          Application.FileLogger.Enabled = false;
          BitTorrent = {
            MergeTrackersEnabled = true;
            Session = {
              DefaultSavePath = "/media/Torrents";
              AddExtensionToIncompleteFiles = true;

              AddTrackersEnabled = true;
              AdditionalTrackers = builtins.readFile "${inputs.trackerlist}/trackers_all.txt";
              AnnounceToAllTrackers = true;

              MaxActiveDownloads = 100;
              MaxActiveUploads = 50;
              MaxActiveCheckingTorrents = 50;
              MaxActiveTorrents = 150;
              IgnoreSlowTorrentsForQueueing = true;
              GlobalUPSpeedLimit = 30720;

              MultiConnectionsPerIp = true;
              uTPMixedMode = "Proportional";

              DiskIOType = "SimplePreadPwrite"; # reduce RAM usage maybe
            };
          };
          Preferences.WebUI.LocalHostAuth = false;
        };
      };

      qui = {
        enable = true;
        secretFile = "/run/agenix/qui/session-secret";
        inherit (server) user group;
        settings = {
          port = 7476;
          metricsEnabled = true;
          oidcEnabled = true;
          oidcIssuer = "https://${server.authDomain}/oauth2/openid/qui";
          oidcClientId = "qui";
          oidcRedirectUrl = "https://qui.i.${server.baseDomain}/api/auth/oidc/callback";
          oidcDisableBuiltInLogin = true;
        };

      };

      nginx = {
        upstreams.qui.servers."127.0.0.1:7476" = { };

        virtualHosts."qui.i.${server.baseDomain}".locations."/" = {
          proxyPass = "http://qui";
          proxyWebsockets = true;
        };
      };

      wireguard-netns = {
        proxies = {
          qui = {
            port = 7476;
            inherit (config.services.qui) user group;
          };
        };
      };
    };

    syde.server.samba.shares = {
      Media = {
        path = "/media/Torrents";
      };
    };

    systemd = {
      services.qui = {
        serviceConfig.EnvironmentFile = "/run/agenix/qui/environment";
        useNetworkNamespace = true;
      };

      services.qbittorrent = {
        serviceConfig.Restart = "on-failure"; # https://github.com/qbittorrent/qBittorrent/issues/23833
        useNetworkNamespace = true;
      };
    };
  };
}

{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkForce;
  inherit (config.syde) server;
  inherit (config.services.wireguard-netns) namespace;
  cfg = config.services.qbittorrent;
in
{
  config = mkIf cfg.enable {
    age.secrets.qui = {
      file = "${inputs.secrets}/qui.age";
      owner = server.user;
    };
    age.secrets.quiSessionSecret = {
      file = "${inputs.secrets}/quiSessionSecret.age";
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
              AddTrackersEnabled = true;
              AdditionalTrackers = builtins.readFile "${inputs.trackerlist}/trackers_all.txt";
              AnnounceToAllTrackers = true;
              MaxActiveDownloads = 50;
              MaxActiveUploads = 50;
              MaxActiveCheckingTorrents = 50;
              MaxActiveTorrents = 100;
            };
          };
          Preferences.WebUI.LocalHostAuth = false;
        };
      };

      qui = {
        enable = true;
        secretFile = config.age.secrets.quiSessionSecret.path;
        inherit (server) user group;
        settings = {
          port = 7476;
          metricsEnabled = true;
          oidcEnabled = true;
          oidcIssuer = "https://auth.simonyde.com/oauth2/openid/qui";
          oidcClientId = "qui";
          oidcRedirectUrl = "https://qui.ts.simonyde.com/api/auth/oidc/callback";
          oidcDisableBuiltInLogin = true;
        };

      };

      nginx = {
        upstreams.qui.servers."127.0.0.1:7476" = { };

        virtualHosts."qui.ts.simonyde.com".locations."/" = {
          proxyPass = "http://qui";
          proxyWebsockets = true;
        };
      };
    };

    systemd = mkMerge [
      {
        services.qui.serviceConfig.EnvironmentFile = config.age.secrets.qui.path;
      }

      (mkIf config.services.wireguard-netns.enable {

        services.qbittorrent = {
          bindsTo = [ "netns@${namespace}.service" ];
          requires = [
            "network-online.target"
            "${namespace}.service"
          ];
          serviceConfig = {
            NetworkNamespacePath = [ "/run/netns/${namespace}" ];
            InaccessiblePaths = [
              "/run/nscd"
            ];

            BindReadOnlyPaths = [
              "/etc/netns/${namespace}/resolv.conf:/etc/resolv.conf:norbind"
            ];
          };
        };

        sockets."qbittorrent-proxy" = {
          enable = true;
          description = "Socket for Proxy to qbittorrent";
          listenStreams = [ "8082" ];
          wantedBy = [ "sockets.target" ];
        };

        services."qbittorrent-proxy" = {
          enable = true;
          description = "Proxy to qbittorrent in Network Namespace";
          requires = [
            "qbittorrent.service"
            "qbittorrent-proxy.socket"
          ];
          after = [
            "qbittorrent.service"
            "qbittorrent-proxy.socket"
          ];
          unitConfig = {
            JoinsNamespaceOf = "qbittorrent.service";
          };
          serviceConfig = {
            ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:8082";
            PrivateNetwork = "yes";
            User = config.services.qbittorrent.user;
            Group = config.services.qbittorrent.group;
          };
        };
      })
    ];

  };
}

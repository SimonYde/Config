{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.syde) server;

  mediaDir = cfg.mediaDir;

  cfg = config.services.jellyfin;
in
{
  options.services.jellyfin = {
    mediaDir = lib.mkOption {
      type = lib.types.path;
      default = cfg.dataDir;
    };
  };

  config = lib.mkIf cfg.enable {

    users.users.${server.user}.extraGroups = [ "nextcloud" ];

    services = {
      jellyfin = {
        inherit (server) user;
        group = "nextcloud";
        openFirewall = true;
      };

      nginx = {
        upstreams.jellyfin.servers."127.0.0.1:8096" = { };

        virtualHosts."film.${config.syde.server.baseDomain}".locations."/" = {
          proxyPass = "http://jellyfin";
          proxyWebsockets = true;
        };
      };
    };

    # NOTE: 2025-08-01 Simon Yde, remember to set `known proxy` option in jellyfin admin console under `Networking`.
    syde.services.fail2ban.jails.jellyfin = {
      serviceName = "jellyfin";
      failRegex = "^.*Authentication request for .* has been denied \\(IP: <HOST>\\)\\..*$";
    };

    # Define the systemd service unit
    systemd.services.jellyfin-chown = {
      description = "Ensure correct ownership for ${mediaDir}";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.coreutils}/bin/chown -R nextcloud:nextcloud ${mediaDir}";
      };
    };

    # Define the systemd path unit
    systemd.paths.jellyfin-chown = {
      description = "Monitor ${mediaDir} for ownership changes";
      pathConfig = {
        PathChanged = mediaDir;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}

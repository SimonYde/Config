{
  config,
  pkgs,
  lib,
  ...
}:
let
  mediaDir = cfg.mediaDir;
  server = config.syde.server;
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
    services = {
      jellyfin = {
        inherit (config.syde.server) user group;
        # Jellyfin can't advertise a reverse proxy on DLNA. Ew.
        openFirewall = false;
      };

      nginx = {
        upstreams.jellyfin.servers."127.0.0.1:8096" = { };

        virtualHosts."film.${config.syde.server.baseDomain}".locations."/" = {
          proxyPass = "http://jellyfin";
          proxyWebsockets = true;
          extraConfig = ''
            add_header Alt-Svc 'h3=":$server_port"; ma=86400';
          '';
        };
      };
    };

    # Define the systemd service unit
    systemd.services.jellyfin-chown = {
      description = "Ensure correct ownership for ${mediaDir}";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.coreutils}/bin/chown -R ${server.user}:${server.group} ${mediaDir}";
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

    # Optional: If you want to ensure the directory exists and has initial ownership
    systemd.services.jellyfin-chown-initial = {
      description = "Initial ownership setup for ${mediaDir}";
      wantedBy = [ "multi-user.target" ];
      before = [ "jellyfin-chown.path" ];

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.coreutils}/bin/mkdir -p ${mediaDir}
        ${pkgs.coreutils}/bin/chown -R ${server.user}:${server.group} ${mediaDir}
      '';
    };
  };

}

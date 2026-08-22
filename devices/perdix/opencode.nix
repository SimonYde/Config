{
  config,
  lib,
  username,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  inherit (config.syde) server;
  cfg = config.services.opencode;
in
{
  options = {
    services.opencode = {
      enable = mkEnableOption "OpenCode";
      port = mkOption {
        type = types.port;
        example = 8382;
        default = 4096;
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.opencode = {
        enable = true;
        web = {
          enable = true;
          extraArgs = [
            "--hostname"
            "127.0.0.1"
            "--port"
            "${toString cfg.port}"
            "--cors"
            "https://opencode.ts.${server.baseDomain}"
          ];
        };
      };
    };

    services.nginx = {
      upstreams.opencode.servers."127.0.0.1:${toString cfg.port}" = { };

      virtualHosts."opencode.ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://opencode";
        proxyWebsockets = true;
      };
    };
  };
}

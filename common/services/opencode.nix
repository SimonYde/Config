{
  config,
  lib,
  username,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
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
    age.secrets.opencodeEnvironmentFile = {
      file = "${inputs.secrets}/opencodeEnvironmentFile.age";
      owner = username;
    };

    home-manager.users.${username} = {
      programs = {
        mcp.enable = true;

        opencode = {
          enable = true;
          web = {
            enable = true;
            environmentFile = config.age.secrets.opencodeEnvironmentFile.path;

            extraArgs = [
              "--hostname"
              "127.0.0.1"
              "--port"
              "${toString cfg.port}"
              "--cors"
              "https://opencode.i.${server.baseDomain}"
            ];
          };
        };
      };
    };

    services.nginx = {
      upstreams.opencode.servers."127.0.0.1:${toString cfg.port}" = { };

      virtualHosts."opencode.i.${server.baseDomain}".locations."/" = {
        proxyPass = "http://opencode";
        proxyWebsockets = true;
      };
    };
  };
}

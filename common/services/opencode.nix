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

  hostName = "opencode.${server.internalDomain}";
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
        mcp.enable = false;

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
              "https://${hostName}"
            ];
          };
        };
      };
    };

    services.nginx = {
      upstreams.opencode.servers."127.0.0.1:${toString cfg.port}" = { };

      virtualHosts.${hostName}.locations."/" = {
        proxyPass = "http://opencode";
        proxyWebsockets = true;
      };
    };
  };
}

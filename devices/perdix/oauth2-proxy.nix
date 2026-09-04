{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.syde) server;

  cfg = config.services.oauth2-proxy;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets.oauth2ProxySecrets = {
      file = "${inputs.secrets}/oauth2-proxy/secrets-perdix.age";
      owner = "oauth2-proxy";
    };

    services.oauth2-proxy = {
      enable = true;
      oidcIssuerUrl = "https://auth.${server.baseDomain}/oauth2/openid/perdix";
      clientID = "perdix";

      nginx = {
        domain = "perdix-auth.i.${server.baseDomain}";
        virtualHosts = { };
      };
    };
  };
}

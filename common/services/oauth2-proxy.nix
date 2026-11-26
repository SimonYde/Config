{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.oauth2-proxy;
  inherit (config.syde) server;
in
{
  config = lib.mkIf cfg.enable {

    services = {
      redis.servers.oauth2_proxy = {
        enable = true;
        user = "oauth2-proxy";
      };

      oauth2-proxy = {
        provider = "oidc";
        keyFile = config.age.secrets.oauth2ProxySecrets.path;

        cookie.domain = ".simonyde.com";
        email.domains = [ "*" ];

        extraConfig = {
          code-challenge-method = "S256";
          whitelist-domain = "*.simonyde.com";
          reverse-proxy = true;
          scope = "openid email profile groups_name";
          session-store-type = "redis";
          redis-connection-url = "unix:/run/redis-oauth2_proxy/redis.sock";
        };
      };
    };
  };
}

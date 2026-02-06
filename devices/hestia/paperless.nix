{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.syde) server;
  cfg = config.services.paperless;
in
{
  config = mkIf cfg.enable {
    age.secrets.paperlessAuthConfig = {
      file = "${inputs.secrets}/paperlessAuthConfig.age";
      owner = "paperless";
    };

    services = {
      paperless = {
        domain = "paperless.${server.baseDomain}";

        configureTika = true;
        database.createLocally = true;
        environmentFile = config.age.secrets.paperlessAuthConfig.path;

        settings = {
          PAPERLESS_OCR_LANGUAGE = "dan+eng";
          PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
          PAPERLESS_DISABLE_REGULAR_LOGIN = true;
          PAPERLESS_OCR_USER_ARGS = {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
          PAPERLESS_CONSUMER_IGNORE_PATTERN = [
            ".DS_STORE/*"
            "desktop.ini"
          ];
        };
      };

      nginx = {
        upstreams.paperless.servers."127.0.0.1:28981" = { };

        virtualHosts.${cfg.domain} = {
          locations."/" = {
            proxyPass = "http://paperless";
            proxyWebsockets = true;

            extraConfig = ''
              client_max_body_size 512m;
            '';
          };
        };
      };
    };

  };
}

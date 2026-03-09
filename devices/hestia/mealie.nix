{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (config.syde) email server;
  inherit (lib) mkForce mkIf;
  cfg = config.services.mealie;
in

{
  config = mkIf cfg.enable {
    age.secrets.mealieCredentials = {
      file = "${inputs.secrets}/mealieCredentials.age";
    };

    services = {
      mealie = {
        listenAddress = "127.0.0.1";
        port = 9000;
        database.createLocally = true;

        credentialsFile = config.age.secrets.mealieCredentials.path;

        settings = {
          OIDC_AUTH_ENABLED = "true";
          OIDC_SIGNUP_ENABLED = "true";
          OIDC_CONFIGURATION_URL = "https://${server.authDomain}/oauth2/openid/mealie/.well-known/openid-configuration";
          OIDC_PROVIDER_NAME = "Kanidm";
          OIDC_CLIENT_ID = "mealie";
          OIDC_USER_GROUP = "mealie_users@${server.authDomain}";
          OIDC_ADMIN_GROUP = "mealie_admins@${server.authDomain}";
          OIDC_SIGNING_ALGORITHM = "ES256";
          ALLOW_PASSWORD_LOGIN = "false";

          SMTP_HOST = email.smtpServer;
          SMTP_PORT = email.smtpPort;
          SMTP_USER = email.smtpUsername;
          SMTP_FROM_EMAIL = email.fromAddress;
          SMTP_FROM_NAME = "Mealie";

          DEFAULT_GROUP = "Alle";
          DEFAULT_HOUSEHOLD = "Klan";
        };
      };

      nginx = {
        upstreams.mealie.servers."${cfg.listenAddress}:${toString cfg.port}" = { };

        virtualHosts."opskrifter.${server.baseDomain}" = {
          locations."/" = {
            proxyPass = "http://mealie";
            proxyWebsockets = true;
          };
        };
      };
    };

    # Process hardening
    systemd.services.mealie.serviceConfig = {
      CapabilityBoundingSet = "";
      DeviceAllow = ""; # ProtectClock adds DeviceAllow=char-rtc r
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateMounts = true;
      PrivateNetwork = false; # Needs to serve web page
      PrivateTmp = true;
      PrivateUsers = true;
      ProtectClock = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectSystem = "strict";
      ProtectControlGroups = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "mbind"
        "@system-service"
        "~@privileged @setuid @keyring"
      ];
      UMask = "0066";
    };
  };
}

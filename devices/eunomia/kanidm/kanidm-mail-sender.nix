{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  inherit (config.syde) email;
  inherit (config.syde) server;
  inherit (server) authDomain;

  cfg = config.services.kanidm.mailSender;

  toml = pkgs.formats.toml { };
  kanidmPkg = config.services.kanidm.package;

  # Kanidm requires smtps:// for implicit TLS (port 465) and smtp:// for
  # STARTTLS. The latter is upgraded to a required TLS connection at runtime.
  mailRelayScheme = if email.smtpPort == 465 then "smtps" else "smtp";

  # Non-secret settings only. The token and SMTP password are appended at
  # runtime from systemd credentials.
  mailSenderConfig = toml.generate "kanidm-mail-sender.toml" {
    instance_display_name = "Kanidm (${authDomain})";
    instance_url = "https://${authDomain}";

    mail_from_address = email.fromAddress;
    mail_reply_to_address = email.toAddress;
    mail_relay = "${mailRelayScheme}://${email.smtpServer}:${toString email.smtpPort}";
    mail_username = email.smtpUsername;
  };

  clientConfig = toml.generate "kanidm-client.toml" {
    uri = "https://${authDomain}";
  };
in
{
  options.services.kanidm.mailSender = {
    enable = mkEnableOption "kanidm-mail-sender service";
    mailTokenFile = mkOption {
      type = types.path;
      description = "Path to a file containing a mail sender service account token";
    };
  };

  config = mkIf cfg.enable {
    # API token for the `mail-sender` service account in `idm_message_senders`.
    systemd.services.kanidm-mail-sender = {
      description = "Kanidm mail sender";
      wantedBy = [ "multi-user.target" ];
      after = [
        "kanidm.service"
        "nginx.service"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        DynamicUser = true;
        RuntimeDirectory = "kanidm-mail-sender";
        RuntimeDirectoryMode = "0700";
        UMask = "0077";
        LoadCredential = [
          "token:${cfg.mailTokenFile}"
          "smtp-pass:${email.smtpPasswordPath}"
        ];
        Restart = "on-failure";
        RestartSec = "10s";

        # Hardening
        AmbientCapabilities = [ ];
        CapabilityBoundingSet = "";
        DeviceAllow = ""; # ProtectClock adds DeviceAllow=char-rtc r
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProcSubset = "pid";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          # nss-resolve talks to systemd-resolved over a UNIX socket
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
      };

      script = ''
        cfg=/run/kanidm-mail-sender/mail-sender.toml

        # Escape values loaded from credentials before embedding them in a TOML
        # basic string. Command substitution already strips trailing newlines.
        escape_toml() {
          local value=$1
          value=''${value//\\/\\\\}
          value=''${value//\"/\\\"}
          printf '%s' "$value"
        }

        {
          ${pkgs.coreutils}/bin/cat ${mailSenderConfig}
          printf 'token = "%s"\n' "$(escape_toml "$(${pkgs.coreutils}/bin/cat "$CREDENTIALS_DIRECTORY/token")")"
          printf 'mail_password = "%s"\n' "$(escape_toml "$(${pkgs.coreutils}/bin/cat "$CREDENTIALS_DIRECTORY/smtp-pass")")"
        } > "$cfg"

        exec ${kanidmPkg}/bin/kanidm-mail-sender -c ${clientConfig} -m "$cfg"
      '';
    };
  };
}

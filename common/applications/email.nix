{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    ;
  cfg = config.syde.email;
in

{
  options.syde.email = {
    enable = mkEnableOption "Email sending functionality";
    fromAddress = mkOption {
      description = "The 'from' address";
      type = types.str;
      default = "john@example.com";
    };
    toAddress = mkOption {
      description = "The 'to' address";
      type = types.str;
      default = "john@example.com";
    };
    smtpServer = mkOption {
      description = "The SMTP server address";
      type = types.str;
      default = "smtp.example.com";
    };
    smtpUsername = mkOption {
      description = "The SMTP username";
      type = types.str;
      default = "john@example.com";
    };
    smtpPasswordPath = mkOption {
      description = "Path to the secret containing SMTP password";
      type = types.path;
    };
    smtpPort = mkOption {
      description = "Port to be used for TLS";
      type = types.port;
      default = 587;
    };
  };

  config = mkIf cfg.enable {
    programs.msmtp = {
      enable = true;
      defaults = {
        aliases = "/etc/aliases";
        tls = true;
        port = cfg.smtpPort;
      };

      accounts.default = {
        auth = true;
        host = cfg.smtpServer;
        from = cfg.fromAddress;
        user = cfg.smtpUsername;
        tls = true;
        passwordeval = "${pkgs.coreutils}/bin/cat ${cfg.smtpPasswordPath}";
      };
    };

    services.zfs.zed = {
      enableMail = false;
      settings = {
        ZED_DEBUG_LOG = "/tmp/zed.debug.log";

        ZED_EMAIL_ADDR = [ "root" ];
        ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
        ZED_EMAIL_OPTS = "@ADDRESS@";

        ZED_NOTIFY_INTERVAL_SECS = 3600;
        ZED_NOTIFY_VERBOSE = true;

        ZED_USE_ENCLOSURE_LEDS = true;
        ZED_SCRUB_AFTER_RESILVER = true;
      };
    };

    environment.etc.aliases.text = ''
      root: ${cfg.smtpUsername}
    '';
  };
}

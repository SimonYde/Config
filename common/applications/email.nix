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
  };

  config = mkIf cfg.enable {
    programs.msmtp = {
      enable = true;
      accounts.default = {
        auth = true;
        host = cfg.smtpServer;
        from = cfg.fromAddress;
        user = cfg.smtpUsername;
        tls = true;
        passwordeval = "${pkgs.coreutils}/bin/cat ${cfg.smtpPasswordPath}";
      };
    };
  };
}

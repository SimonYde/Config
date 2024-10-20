{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.syde.email;
in
{
  config = lib.mkIf cfg.enable {
    accounts.email = {
      maildirBasePath = "~/Mail";
      accounts.simonyde = {
        primary = true;
        realName = "Simon Yde";
        userName = "mail@simonyde.com";
        address = "mail@simonyde.com";
        aliases = [ "@simonyde.com" ];
        # passwordCommand = "alias cat=cat; cat ../../../.secrets/mailpassword";
        # passwordCommand = "cat ../../../.secrets/mailpassword";
        imap = {
          host = "127.0.0.1";
          port = 1143;
          tls.useStartTls = true;
        };
        smtp = {
          host = "127.0.0.1";
          port = 1025;
          tls.useStartTls = true;
        };
        thunderbird.enable = true;
      };
    };
    programs.thunderbird = {
      enable = true;
      profiles.simonyde.isDefault = true;
      package = pkgs.thunderbird;
      settings = {
        "privacy.donottrackheader.enabled" = true;
      };
    };

    home.packages = [ pkgs.protonmail-bridge ];
  };

  options.syde.email = {
    enable = lib.mkEnableOption "email configuration";
  };
}

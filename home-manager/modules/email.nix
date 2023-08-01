{ config, lib, pkgs, ... }:

{
  accounts.email = lib.mkIf config.programs.thunderbird.enable {
    maildirBasePath = "~/Mail";
    accounts.simonyde = {
      primary = true;
      realName = "Simon Yde";
      userName = "mail@simonyde.com";
      address = "mail@simonyde.com";
      aliases = [
        "@simonyde.com"
      ];
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
      thunderbird.enable = config.programs.thunderbird.enable;
    };
  };
  programs.thunderbird = {
    profiles.simonyde.isDefault = true;
    package = pkgs.unstable.thunderbird;
    settings = { 
      "privacy.donottrackheader.enabled" = true;
    };
  };

  home.packages = lib.mkIf config.programs.thunderbird.enable [
    pkgs.protonmail-bridge
  ];
}

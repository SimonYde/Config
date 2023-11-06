{ config, lib, ... }:

let cfg = config.syde.ssh; in
{
  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.configHome}/gpg";
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      pinentryFlavor = "gtk2";
    };
  };

  options.syde.ssh = {
    enable = lib.mkEnableOption "ssh and gpg";
  };
}

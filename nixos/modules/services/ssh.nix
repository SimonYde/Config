{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.syde.ssh;
in
{
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  options.syde.ssh = {
    enable = mkEnableOption "SSH configuration";
  };
}

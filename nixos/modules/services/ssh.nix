{
  lib,
  config,
  ...
}: let
  cfg = config.syde.ssh;
in {
  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  options.syde.ssh = {
    enable = lib.mkEnableOption "SSH configuration";
  };
}

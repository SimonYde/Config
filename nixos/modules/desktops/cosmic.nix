{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkForce;
  user = config.syde.user;
  cfg = config.services.desktopManager.cosmic;
in

{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ];

    # hardware.system76.enableAll = true;

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-term
    ];

    users.users.${user}.extraGroups = [ "adm" ];
    programs.light.enable = mkForce false;
    services.blueman.enable = mkForce false;
    services.greetd.settings = {
      # auto-login support
      initial_session = {
        user = "${config.syde.user}";
        command = "start-cosmic --in-login-shell";
      };
    };
  };

  imports = [ inputs.nixos-cosmic.nixosModules.default ];
}

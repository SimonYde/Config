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

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-term
    ];

    users.users.${user}.extraGroups = [ "adm" ];
    programs.light.enable = mkForce false;
    services.blueman.enable = mkForce false;
    services.greetd.settings = {
      initial_session = {
        command = "start-cosmic --in-login-shell";
        user = config.syde.user;
      };
    };
  };

  imports = [ inputs.nixos-cosmic.nixosModules.default ];
}

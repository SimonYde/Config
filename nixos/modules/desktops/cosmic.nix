{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.services.desktopManager.cosmic;
in

{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ];

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-term
    ];

    users.extraGroups.adm.members = [ config.syde.user ];

    services.greetd.settings = {
      initial_session = {
        command = "start-cosmic --in-login-shell";
        user = config.syde.user;
      };
    };
  };

  imports = [ inputs.nixos-cosmic.nixosModules.default ];
}

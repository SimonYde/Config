{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkForce;
  cfg = config.services.desktopManager.cosmic;
in

{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ];
    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-term
    ];
    programs.light.enable = mkForce false;
    services.blueman.enable = mkForce false;
  };

  imports = [ inputs.nixos-cosmic.nixosModules.default ];
}

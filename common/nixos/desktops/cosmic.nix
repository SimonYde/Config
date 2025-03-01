{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkForce mkIf;
  inherit (config.syde) user;
  cfg = config.services.desktopManager.cosmic;
in

{
  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  config = mkIf cfg.enable {
    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-term
    ];

    users.extraGroups.adm.members = [ user ];

    services.greetd.settings = {
      initial_session = {
        inherit user;
        command = "start-cosmic --in-login-shell";
      };
    };

    home-manager.users.${user} = {
      services.gammastep.enable = mkForce false; # TODO: find night-light alternative

      home.packages = with pkgs; [
        wl-clipboard # clipboard manager
      ];

      syde.gui.file-manager = {
        mime = mkDefault "com.system76.CosmicFiles";
        package = mkDefault pkgs.cosmic-files;
      };
    };
  };
}

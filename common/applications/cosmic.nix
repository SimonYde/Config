{
  lib,
  pkgs,
  username,
  config,
  ...
}:

let
  inherit (lib) mkDefault mkForce mkIf;

  cfg = config.services.desktopManager.cosmic;
in
{
  config = mkIf cfg.enable {
    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-term
    ];

    programs.regreet.enable = mkForce false;

    services = {
      displayManager.cosmic-greeter.enable = true;

      greetd.settings = {
        initial_session = {
          user = username;
          command = mkForce "start-cosmic --in-login-shell";
        };
      };
    };

    home-manager.users.${username} = {
      home.packages = with pkgs; [
        wl-clipboard # clipboard manager
      ];

      syde.gui.file-manager = {
        name = mkDefault "com.system76.CosmicFiles";
        package = mkDefault pkgs.cosmic-files;
      };
    };
  };
}

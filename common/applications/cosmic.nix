{
  lib,
  pkgs,
  username,
  config,
  ...
}:

let
  inherit (lib) mkDefault mkIf;

  cfg = config.services.desktopManager.cosmic;
in
{
  config = mkIf cfg.enable {
    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-term
    ];

    services = {
      displayManager.cosmic-greeter.enable = true;

      greetd.settings = {
        initial_session = {
          user = username;
          command = "start-cosmic --in-login-shell";
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

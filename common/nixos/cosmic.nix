{
  lib,
  pkgs,
  username,
  ...
}:

let
  inherit (lib) mkDefault;
in
{
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-term
  ];

  services = {
    desktopManager.cosmic.enable = true;
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
      mime = mkDefault "com.system76.CosmicFiles";
      package = mkDefault pkgs.cosmic-files;
    };
  };
}

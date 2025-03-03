{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault;
  inherit (config.syde) user;
in
{
  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-term
  ];

  users.extraGroups.adm.members = [ user ];

  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;

    greetd.settings = {
      initial_session = {
        inherit user;
        command = "start-cosmic --in-login-shell";
      };
    };
  };

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wl-clipboard # clipboard manager
    ];

    syde.gui.file-manager = {
      mime = mkDefault "com.system76.CosmicFiles";
      package = mkDefault pkgs.cosmic-files;
    };
  };
}

{ inputs, pkgs, config, ... }:

{
  nixpkgs.overlays = [
    inputs.nix-ld-rs.overlays.default
  ];
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../modules/programs/nix.nix
    ../modules/services/syncthing.nix
    ../modules/programs/doas.nix
    ../../home-manager/modules/themes.nix
  ];

  networking.hostName = "icarus";
  system.stateVersion = "23.05";
  time.timeZone = "Europe/Copenhagen";
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "syde";
    startMenuLaunchers = true;
    nativeSystemd = true;
  };

  users.users.syde = {
    isNormalUser = true;
    description = "Simon Yde";
    shell = pkgs.fish;
    uid = 1000;
    extraGroups = [ "video" "networkmanager" "wheel" ];
  };

  environment.sessionVariables = with config.themes; {
    GTK_THEME = if prefer-dark then gtk.darkTheme else gtk.lightTheme;
  };


  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  programs.fish.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;
  # programs.command-not-found.enable = true;
}

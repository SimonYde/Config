{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ../modules/programs/nix.nix
    ../modules/programs/doas.nix
  ];

  networking.hostName = "icarus";
  system.stateVersion = "23.05";
  time.timeZone = "Europe/Copenhagen";
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    # automountPath = "/mnt";
    defaultUser = "syde";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  users.users.syde = {
    isNormalUser = true;
    description = "Simon Yde";
    extraGroups = [ "video" "networkmanager" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;
  programs.command-not-found.enable = true;
}

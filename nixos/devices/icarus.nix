{ pkgs, inputs, modulesPath, ... }:

{
  imports = [
    # "${modulesPath}/profiles/minimal.nix"
    inputs.nixos-wsl.nixosModules.wsl
    ../modules/programs/nix.nix
    ../modules/hardware/graphics/nvidia.nix  
  ];

  networking.hostName = "icarus";
  system.stateVersion = "23.05";
  wsl = {
    enable = true;
    automountPath = "/mnt";
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
  ];

  programs.command-not-found.enable = true;
}

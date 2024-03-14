{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [
    inputs.nix-ld-rs.overlays.default
  ];
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.vscode-server.nixosModules.default
    ../modules/programs/nix.nix
    ../modules/programs/cachix.nix
    ../modules/services/syncthing.nix
    ../modules/programs/doas.nix
  ];

  networking.hostName = "icarus";
  system.stateVersion = "23.11";
  time.timeZone = "Europe/Copenhagen";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "syde";
    startMenuLaunchers = true;
    nativeSystemd = true;
    useWindowsDriver = true;
  };

  users.users.syde = {
    isNormalUser = true;
    description = "Simon Yde";
    shell = pkgs.fish;
    extraGroups = [ "video" "networkmanager" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  services.vscode-server.enable = false;

  programs = {
    dconf.enable = true;
    fish.enable = true;
    nix-ld.enable = true;
    nix-ld.package = pkgs.nix-ld-rs;
  };
}

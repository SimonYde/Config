{...}:

{
  home = {
    username = "syde";
    homeDirectory = "/home/syde";
    stateVersion = "23.05";
  };
  imports = [
    ./standard.nix
  ];
  programs.home-manager.enable = true;
}

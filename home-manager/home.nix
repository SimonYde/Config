{ ... }:
{
  programs.home-manager.enable = true;

  home = {
    username = "syde";
    homeDirectory = "/home/syde";
    stateVersion = "24.11";
  };
}

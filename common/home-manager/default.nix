{ ... }:

{
  home.stateVersion = "24.11";
  home.preferXdgDirectories = true;
  xdg.enable = true;

  imports = [
    ./modules
  ];
}

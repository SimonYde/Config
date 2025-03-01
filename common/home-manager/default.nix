{ ... }:

{
  home.stateVersion = "24.11";
  home.preferXdgDirectories = true;
  xdg.enable = true;

  imports = [
    ./gui.nix
    ./programming.nix
    ./ssh.nix
    ./terminal.nix

    ./programs
    ./desktops
    ./services
  ];
}

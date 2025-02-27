{ ... }:
{
  imports = [
    ./gui.nix
    ./programming.nix
    ./ssh.nix
    ./terminal.nix
    ./theming.nix

    ./programs
    ./desktops
    ./services
  ];
}

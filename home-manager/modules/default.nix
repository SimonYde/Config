{ ... }:
{
  imports = [
    ./ssh.nix
    ./theming.nix
    ./programming.nix

    ./programs
    ./desktops
    ./services
  ];
}

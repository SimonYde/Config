{ ... }:
{
  imports = [
    ./ssh.nix
    ./theming.nix

    ./programs
    ./desktops
    ./services
    ./programming
  ];
}

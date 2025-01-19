{ ... }:
{
  imports = [
    ./email.nix
    ./ssh.nix

    ./programs
    ./desktops
    ./theming
    ./services
    ./programming
  ];
}

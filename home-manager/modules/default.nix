{ ... }:
{
  imports = [
    ./email.nix
    ./fonts.nix
    ./ssh.nix

    ./programs
    ./desktops
    ./theming
    ./services
    ./languages
  ];
}

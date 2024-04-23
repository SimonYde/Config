{...}: {
  imports = [
    ./email.nix
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
    ./ssh.nix
    ./theming.nix

    ./programs
    ./desktops
    ./services
    ./languages
  ];
}

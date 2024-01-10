{...}:

{
  imports = [
    # ---Editors---
    ./helix.nix
    ./neovim.nix

    # ---CLI Tools---
    ./bat.nix
    ./direnv.nix
    ./eza.nix
    ./git.nix
    ./lazygit.nix
    ./lf.nix
    ./ripgrep.nix
    ./skim.nix
    ./starship.nix
    ./thefuck.nix
    ./yazi.nix
    ./zellij
    ./zoxide.nix

    # ---Terminals---
    ./alacritty.nix
    ./kitty.nix
    ./wezterm.nix

    # ---GUI programs---
    ./brave.nix
    ./firefox
    ./i3status-rust.nix
    ./mpv.nix
    ./rofi
    ./swaylock.nix
    ./thunar.nix
    ./vscode.nix
    ./waybar.nix
    ./zathura.nix

    # ---Shells---
    ./bash.nix
    ./fish.nix
    ./nushell.nix
    ./zsh.nix

  ];
}

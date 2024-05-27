{ ... }:
{
  imports = [
    # ---Editors---
    ./helix.nix
    ./neovim.nix

    # ---CLI Tools---
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./git.nix
    ./lazygit.nix
    ./lf.nix
    ./ripgrep.nix
    ./skim.nix
    ./fzf.nix
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
    ./imv.nix
    ./nix-index.nix
    ./mpv.nix
    ./rofi
    ./swaylock.nix
    ./hyprlock.nix
    ./thunar.nix
    ./vscode.nix
    ./waybar.nix
    ./wlogout.nix
    ./zathura.nix

    # ---Shells---
    ./bash.nix
    ./fish.nix
    ./nushell.nix
    ./zsh.nix
  ];
}

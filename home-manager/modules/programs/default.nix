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
    ./ripgrep.nix
    ./skim.nix
    ./fzf.nix
    ./fd.nix
    ./starship.nix
    ./thefuck.nix
    ./tmux.nix
    ./yazi.nix
    ./zellij
    ./zoxide.nix

    # ---Terminals---
    ./alacritty.nix
    ./kitty.nix
    ./wezterm.nix

    # ---GUI programs---
    ./brave.nix
    ./discord.nix
    ./emacs.nix
    ./firefox
    ./hyprlock.nix
    ./i3status-rust.nix
    ./imv.nix
    ./mangohud.nix
    ./mpv.nix
    ./nix-index.nix
    ./rofi
    ./swaylock.nix
    ./thunar.nix
    ./vscode.nix
    ./waybar
    ./wlogout.nix
    ./zathura.nix
    ./zen

    # ---Shells---
    ./bash.nix
    ./fish.nix
    ./nushell.nix
    ./zsh.nix
  ];

}

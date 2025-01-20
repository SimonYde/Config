{ ... }:
{
  imports = [
    # ---Editors---
    ./helix.nix
    ./neovim.nix

    # ---CLI Tools---
    ./atuin.nix
    ./bat.nix
    ./carapace.nix
    ./direnv.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./jujutsu.nix
    ./pay-respects.nix
    ./ripgrep.nix
    ./skim.nix
    ./starship.nix
    ./tmux.nix
    ./yazi.nix
    ./zellij
    ./zoxide.nix

    # ---Terminals---
    ./alacritty.nix
    ./ghostty.nix
    ./kitty.nix
    ./wezterm.nix

    # ---GUI programs---
    ./brave.nix
    ./discord.nix
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
    ./waybar
    ./wlogout.nix
    ./zathura.nix

    # ---Shells---
    ./bash.nix
    ./fish.nix
    ./nushell
  ];

}

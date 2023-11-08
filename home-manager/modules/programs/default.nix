{...}:

{
  imports = [
    # ---Editors---
    ./helix.nix
    ./neovim.nix

    # ---CLI Tools---
    ./bat.nix
    ./direnv.nix
    ./exa.nix
    ./git.nix
    ./lazygit.nix
    ./lf.nix
    ./skim.nix
    ./starship.nix
    ./zellij
    ./zoxide.nix

    # ---Terminals---
    ./alacritty.nix
    ./kitty.nix
    ./wezterm.nix

    # ---GUI programs---
    ./brave.nix
    ./firefox
    ./vscode.nix
    ./zathura.nix

    # ---Shells---
    ./fish.nix
    ./nushell.nix
    ./zsh.nix
  ];
}

{ lib, pkgs, ... }:

{
  programs = {
    # Shells
    fish.enable    = true;
    nushell.enable = false;
    zsh.enable     = false;

    # CLI tools
    bat.enable      = true;
    exa.enable      = true;
    git.enable      = true;
    lazygit.enable  = true;
    lf.enable       = true;
    skim.enable     = true;
    starship.enable = true;
    zoxide.enable   = true;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.packages = with pkgs; [
    # CLI Tools
    any-nix-shell
    entr
    grawlix
    nur.repos.jo1gi.audiobook-dl-git
    ripgrep
    speedtest-cli
  ];

  imports = [
    ./modules/alacritty.nix
    ./modules/exa.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/nushell.nix
    ./modules/skim.nix
    ./modules/starship.nix
    ./modules/zellij.nix
    ./modules/zoxide.nix
    ./modules/zsh.nix
  ];
}

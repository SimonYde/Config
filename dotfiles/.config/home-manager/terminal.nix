{ pkgs, ... }:

{
  programs = {
    # Shells
    zsh.enable = false;
    nushell.enable = true;
    fish.enable = true;

    # CLI tools
    starship.enable = true;
    zoxide.enable = true;
    exa.enable = true;
    git.enable = true;
    bat.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.packages = with pkgs; [
    # CLI Tools
    speedtest-cli
    rclone 
    ripgrep
    entr
    any-nix-shell
    nur.repos.jo1gi.audiobook-dl-git
    grawlix
  ];

  imports = [
    ./modules/alacritty.nix
    ./modules/starship.nix
    ./modules/zellij.nix
    ./modules/zoxide.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/fish.nix
    ./modules/nushell.nix
  ];
}

{ lib, pkgs, ... }:

{
  config = {
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
      zellij.enable   = true;
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
    ];

    syde.terminal.aliases = {
      sudo = "doas";
      cat  = "bat";
      c    = "clear";
    };
  };

  imports = [
    ./modules/alacritty.nix
    ./modules/exa.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/nushell.nix
    ./modules/bat.nix
    ./modules/skim.nix
    ./modules/starship.nix
    ./modules/zellij.nix
    ./modules/zoxide.nix
    ./modules/zsh.nix
  ];

  options.syde.terminal = with lib; {
    aliases = mkOption { type = types.attrsOf types.str; };
  };
}

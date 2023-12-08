{ pkgs, lib, ... }:

{
  config = {
    programs = {
      # Shells
      bash.enable    = true;
      fish.enable    = true;
      nushell.enable = true;
      zsh.enable     = false;

      # CLI tools
      bat.enable      = true;
      direnv.enable   = true;
      eza.enable      = true;
      git.enable      = true;
      lazygit.enable  = true;
      lf.enable       = false;
      ripgrep.enable  = true;
      skim.enable     = true;
      starship.enable = true;
      yazi.enable     = true;
      zellij.enable   = true;
      zoxide.enable   = true;
    };

    home.sessionPath = [
      "$HOME/.local/bin"
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.packages = with pkgs; [
      # CLI Tools
      dogdns
      du-dust
      entr
      fd
      trashy
      jq
      sd
      xh

      pandoc

      grawlix
      pix2tex
      kattis-cli
      nur.repos.jo1gi.audiobook-dl-git
    ];

    home.shellAliases = {
      # sudo = "doas";
      # cat = "bat";
      c   = "clear";
      rt  = "trash put";
      zs  = "zellij --session";
      za  = "zellij attach";
    };
  };

  options.syde.terminal = {
    font = lib.mkOption {
      type = lib.types.str;
      # default = "FiraCode Nerd Font Mono";
      default = "JetBrains Mono Nerd Font Mono";
    };
    fontSize = lib.mkOption {
      type = lib.types.float;
      default = 11.5;
    };
  };
}

{ pkgs, lib, ... }:

{
  config = {
    programs = {
      # Shells
      fish.enable    = true;
      nushell.enable = true;
      zsh.enable     = false;

      # CLI tools
      bat.enable      = true;
      direnv.enable   = true;
      exa.enable      = true;
      git.enable      = true;
      lazygit.enable  = false;
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
      EDITOR = "nvim";
    };

    home.packages = with pkgs; [
      # CLI Tools
      any-nix-shell
      dogdns
      du-dust
      entr
      fd
      ripgrep
      sd
      xh

      pandoc

      grawlix
      nur.repos.jo1gi.audiobook-dl-git
    ];

    home.shellAliases = {
      # sudo = "doas";
      cat = "bat";
      c   = "clear";
    };
  };

  options.syde.terminal = with lib; {
    font = mkOption {
      type = types.str;
      # default = "FiraCode Nerd Font Mono";
      default = "JetBrains Mono Nerd Font Mono";
    };
  };
}

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
      trashy
      jq
      sd
      xh

      pandoc

      grawlix
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
  };
}

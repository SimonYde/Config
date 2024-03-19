{ config, pkgs, lib, ... }:
let 
  cfg = config.syde.terminal;
in 
{
  config = {
    programs = {
      # Shells
      bash.enable    = true;
      fish.enable    = true;
      nushell.enable = false;
      zsh.enable     = true;

      # CLI tools
      atuin.enable     = true;
      bat.enable       = true;
      btop.enable      = true;
      direnv.enable    = true;
      eza.enable       = true;
      git.enable       = true;
      gh.enable        = true;
      lazygit.enable   = true;
      lf.enable        = false;
      nix-index.enable = true;
      ripgrep.enable   = true;
      skim.enable      = true;
      starship.enable  = true;
      thefuck.enable   = true;
      yazi.enable      = true;
      zellij.enable    = true;
      zoxide.enable    = true;
    };

    home.sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

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
      # pix2tex
      nur.repos.jo1gi.audiobook-dl-git
    ];

    home.shellAliases = {
      cat = "bat";
      c   = "clear";
      rt  = "trash put";
      zs  = "zellij --session";
      za  = "zellij attach";
    };
  };

  options.syde.terminal = {
    font = lib.mkOption {
      type = lib.types.enum [
        "FiraCode Nerd Font Mono"
        "JetBrains Mono Nerd Font Mono"
      ];
      default = "JetBrains Mono Nerd Font Mono";
    };
    fontSize = lib.mkOption {
      type = lib.types.float;
      default = 11.5;
    };
    emulator = lib.mkOption {
      type = lib.types.enum [
        "alacritty"
        "kitty"
        "wezterm"
      ];
      default = "alacritty";
    };
    opacity = lib.mkOption {
      type = lib.types.float;
      default = 0.85;
    };
    cursor = lib.mkOption {
      type = lib.types.enum [
        "block"
        "beam"
        "underline"
      ];
      default = "beam";
    };
  };
}

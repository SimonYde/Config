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

  imports = [
    ./modules/alacritty.nix
    ./modules/bat.nix
    ./modules/direnv.nix
    ./modules/exa.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/kitty.nix
    ./modules/lazygit.nix
    ./modules/nushell.nix
    ./modules/skim.nix
    ./modules/starship.nix
    ./modules/wezterm.nix
    ./modules/zellij.nix
    ./modules/zoxide.nix
    ./modules/zsh.nix
  ];

  options.syde.terminal = with lib; {
    font = mkOption {
      type = types.str;
      # default = "FiraCode Nerd Font Mono";
      default = "JetBrains Mono Nerd Font Mono";
    };
  };
}

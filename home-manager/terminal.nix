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
    ./modules/programs/alacritty.nix
    ./modules/programs/bat.nix
    ./modules/programs/direnv.nix
    ./modules/programs/exa.nix
    ./modules/programs/fish.nix
    ./modules/programs/git.nix
    ./modules/programs/kitty.nix
    ./modules/programs/lazygit.nix
    ./modules/programs/nushell.nix
    ./modules/programs/skim.nix
    ./modules/programs/starship.nix
    ./modules/programs/wezterm.nix
    ./modules/programs/zellij.nix
    ./modules/programs/zoxide.nix
    ./modules/programs/zsh.nix
  ];

  options.syde.terminal = with lib; {
    font = mkOption {
      type = types.str;
      # default = "FiraCode Nerd Font Mono";
      default = "JetBrains Mono Nerd Font Mono";
    };
  };
}

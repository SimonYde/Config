{ pkgs, lib, ... }:

{
  config = {
    programs = {
      # Shells
      fish.enable = true;
      nushell.enable = false;
      zsh.enable = false;

      # CLI tools
      bat.enable = true;
      direnv.enable = true;
      exa.enable = true;
      git.enable = true;
      lazygit.enable = false;
      lf.enable = true;
      skim.enable = true;
      starship.enable = true;
      zellij.enable = true;
      zoxide.enable = true;
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
      entr
      ripgrep
      fd
      sd
      du-dust
      xh
      dogdns

      grawlix
      nur.repos.jo1gi.audiobook-dl-git
    ];

    home.shellAliases = {
      # sudo = "doas";
      cat = "bat";
      c = "clear";
    };
  };

  imports = [
    ./modules/alacritty.nix
    ./modules/wezterm.nix
    ./modules/kitty.nix
    ./modules/exa.nix
    ./modules/direnv.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/nushell.nix
    ./modules/bat.nix
    ./modules/skim.nix
    ./modules/lazygit.nix
    ./modules/starship.nix
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

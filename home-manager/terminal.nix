{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    mkEnableOption
    ;
  cfg = config.syde.terminal;
in
{
  config = mkIf cfg.enable {
    programs = {
      # Shells
      fish.enable = true;
      bash.enable = true;
      nushell.enable = true;
      zsh.enable = false;

      # CLI tools
      atuin.enable = true;
      bat.enable = true;
      btop.enable = true;
      direnv.enable = true;
      eza.enable = true;
      fzf.enable = true;
      fastfetch.enable = true;
      fd.enable = true;
      gh.enable = true;
      git.enable = true;
      lazygit.enable = true;
      nix-index.enable = true;
      ripgrep.enable = true;
      skim.enable = true;
      starship.enable = true;
      thefuck.enable = false;
      yazi.enable = true;
      zellij.enable = true;
      zoxide.enable = true;
    };

    home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

    home.packages = with pkgs; [
      # CLI Tools
      dogdns # rust version of `dig`
      du-dust # Histogram of file sizes
      jq # JSON magic
      gnumake
      just # alternative to `gnumake`
      sd # Friendlier `sed`
      trashy # for when `rm -rf` is too scary
      xh # Colorful curl
      yt-dlp

      zip
      unzip

      tokei # Counting lines of code
      tldr # Quick hits on programs

      entr
      pandoc

      nix-output-monitor
      libqalculate
      rclone

      grawlix
      pix2tex
      nur.repos.jo1gi.audiobook-dl-git
    ];

    home.shellAliases = {
      c = "clear";
      tp = "${pkgs.trashy}/bin/trash put";
    };
  };

  options.syde.terminal = {
    enable = mkEnableOption "terminal configuration";
    fontSize = mkOption {
      type = types.float;
      default = 11.5;
    };
    emulator = mkOption {
      type = types.enum [
        "alacritty"
        "kitty"
        "wezterm"
        "foot"
      ];
      default = "kitty";
    };
    opacity = mkOption {
      type = types.float;
      default = 0.85;
    };
    cursor = mkOption {
      type = types.enum [
        "block"
        "beam"
        "underline"
      ];
      default = "beam";
    };
  };
}

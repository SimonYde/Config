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

      # CLI tools
      atuin.enable = true;
      bat.enable = true;
      btop.enable = true;
      direnv.enable = true;
      eza.enable = false;
      fastfetch.enable = true;
      fd.enable = true;
      fzf.enable = true;
      gh.enable = true;
      git.enable = true;
      jq.enable = false;
      jujutsu.enable = true;
      nix-index.enable = true;
      ripgrep.enable = true;
      skim.enable = false;
      starship.enable = true;
      tmux.enable = false;
      yazi.enable = true;
      zellij.enable = true;
      zoxide.enable = true;
    };

    home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

    home.packages = with pkgs; [
      # CLI Tools
      dogdns # rust version of `dig`
      du-dust # Histogram of file sizes

      gnumake # for Makefiles
      just # alternative to `gnumake`

      trashy # for when `rm -rf` is too scary

      zip
      unzip

      tokei # Counting lines of code
      tealdeer # Quick hits on programs (rust alternative to `tldr`)

      pandoc

      libqalculate
      rclone
      imagemagick
      yt-dlp
      grawlix
      pix2tex
      audiobook-dl
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
        "ghostty"
      ];
      default = "ghostty";
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

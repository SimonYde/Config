{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    ;
  cfg = config.syde.terminal;
in
{
  config = mkIf cfg.enable {
    programs = {
      # Shells
      fish.enable = false;
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
      lazygit.enable = true;
      nix-index.enable = true;
      pandoc.enable = true;
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
      erdtree # Tree file view

      lurk # strace alternative
      trippy # network diagnostics

      gnumake # for Makefiles
      just # alternative to `gnumake`

      trashy # for when `rm -rf` is too scary

      isd # Interactive systemd utility
      zip
      unzip

      tokei # Counting lines of code
      tealdeer # Quick hits on programs (rust alternative to `tldr`)

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
      tp = "${getExe pkgs.trashy} put";
    };
  };

  options.syde.terminal = {
    enable = mkEnableOption "terminal configuration";
  };
}

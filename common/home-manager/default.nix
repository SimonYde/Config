{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./programs
    ./development
  ];

  home = {
    stateVersion = "24.11";
    preferXdgDirectories = true;

    sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

    packages = with pkgs; [
      # CLI Tools
      dogdns # rust version of `dig`
      du-dust # Histogram of file sizes
      erdtree # Tree file view

      lurk # strace alternative
      trippy # network diagnostics

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

    shellAliases = {
      c = "clear";
      tp = "${lib.getExe pkgs.trashy} put";
    };
  };

  xdg.enable = true;

  programs = {
    # Shells
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

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.configHome}/gpg";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    pinentryPackage = pkgs.pinentry-tty;
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

}

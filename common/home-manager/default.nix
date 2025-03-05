{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./programs.nix
    ./neovim.nix
    ./development.nix
  ];

  xdg.enable = true;

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

      isd # Interactive systemd utility

      tokei # Counting lines of code
      tealdeer # Quick hits on programs (rust alternative to `tldr`)

      libqalculate
      rclone
      imagemagick
      yt-dlp

      grawlix
      pix2tex
      audiobook-dl

      nix-your-shell
    ];

    # FIXME: hack to reload dbus activated things
    activation.reloadDbus = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
      if [[ -v DBUS_SESSION_BUS_ADDRESS ]]; then
        run ${pkgs.systemd}/bin/busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus ReloadConfig
      fi
    '';
  };

  programs = {
    # Shells
    bash.enable = true;
    nushell.enable = true;

    carapace.enable = true;

    neovim.enable = true;

    # CLI tools
    atuin.enable = true;
    bat.enable = true;
    btop.enable = true;

    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;

    nix-index.enable = true;
    pandoc.enable = true;
    ripgrep.enable = true;
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

  manual.manpages.enable = false;
}

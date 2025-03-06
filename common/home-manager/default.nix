{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./programs.nix
    ./neovim.nix

    inputs.agenix.homeManagerModules.default
  ];

  xdg.enable = true;

  age.package = pkgs.rage;

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
      rsync

      isd # Interactive systemd utility

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
    homedir = "${config.xdg.dataHome}/gpg";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableNushellIntegration = true;
    pinentryPackage = pkgs.pinentry-tty;
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

  manual.manpages.enable = false;
}

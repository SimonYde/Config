{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib) getExe;
in
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index

    ./git.nix
    ./neovim.nix
    ./starship.nix
    ./yazi.nix
  ];

  home = {
    packages = with pkgs; [
      dogdns # rust version of `dig`
      du-dust # Histogram of file sizes
      erdtree # Tree file view

      lurk # strace alternative
      trippy # network diagnostics
      rsync

      systemctl-tui # Alternative to `isd`
    ];

    shellAliases = {
      st = "systemctl-tui";
      ll = "ls -l";
      lla = "ls -la";
      la = "ls -a";
    };
  };

  programs = {
    # Shells
    bash.enable = true;
    fish.enable = true;
    nushell.enable = true;

    # Editor
    neovim.enable = true;
    helix.enable = false;

    # Tools
    atuin.enable = true;
    bat.enable = true;
    btop.enable = true;
    carapace.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    nix-your-shell.enable = true;
    pandoc.enable = true;
    ripgrep.enable = true;
    starship.enable = true;
    television.enable = true;
    yazi.enable = true;
    zellij.enable = true;
    zoxide.enable = true;
  };

  programs.atuin = {
    daemon.enable = true;

    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://atuin.ts.simonyde.com";

      style = "compact";
      enter_accept = true;
      filter_mode_shell_up_key_binding = "session";

      history_filter = [
        "fg *"
        "pkill *"
        "kill *"
        "rm *"
        "rmdir *"
        "mkdir *"
        "touch *"
        "cd *"
      ];
    };
  };

  programs.carapace = {
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  programs.fastfetch.settings = {
    modules = [
      "os"
      "host"
      "kernel"
      "uptime"
      "packages"
      "shell"
      "cpu"
      "gpu"
      "memory"
      "swap"
      "disk"
      "localip"
    ];
  };

  programs.fd = {
    hidden = true;
    ignores = [
      ".git/"
      ".jj/"
      ".direnv/"
    ];
  };

  programs.fzf.defaultCommand = "${getExe pkgs.fd} -H --type file";

  programs.helix.package = pkgs.evil-helix;

  programs.nushell = {
    environmentVariables.CARAPACE_BRIDGES = "fish,bash";

    configFile.text = # nu
      ''
        $env.NU_LIB_DIRS ++= [ '${pkgs.nu_scripts}/share/nu_scripts' ]
        source ${config.lib.meta.mkMutableSymlink ./config.nu}
      '';

    plugins = with pkgs.nushellPlugins; [
      gstat
      query
      formats
      polars
      # skim
    ];
  };

  programs.ripgrep.arguments = [
    "--smart-case"
    "--pretty"
  ];
}

{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) getExe;
  fd = getExe pkgs.fd;

in

{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./neovim.nix
    ./yazi.nix
    ./starship.nix
    ./nushell.nix
  ];

  home.shellAliases = {
    zs = "zellij --session";
    zp = "zellij --session $(basename $PWD)";
    za = "zellij attach $(zellij list-sessions | ${lib.getExe pkgs.fzf} --ansi | awk '{ print $1 }')";
    cat = "bat";
    man = "batman";
  };

  programs.nushell.shellAliases = {
    lt = "eza --tree --level=2 --long --icons --git";
    cat = "bat";
    man = "batman";
  };

  programs.helix = {
    settings = lib.mkForce { }; # NOTE: This is here so stylix does not mess with my settings
  };
  programs.atuin = {
    flags = [
    ];
    settings = {
      auto_sync = false;
      history_filter = [
        "fg *"
        "pkill *"
        "kill *"
        "rm *"
        "rmdir *"
        "mkdir *"
        "touch *"
      ];
      style = "compact";
      enter_accept = true;
      filter_mode_shell_up_key_binding = "session";
    };
  };

  programs.bat = {
    config = {
      pager = "less -FR";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };

  programs.carapace = {
    enableFishIntegration = false;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  programs.eza = {
    icons = "auto";
  };

  programs.fish = {
    interactiveShellInit = # fish
      ''
        ${getExe pkgs.any-nix-shell} fish | source
        set fish_greeting ""
      '';

    functions = {
      fish_user_key_bindings = # fish
        ''
          fish_default_key_bindings -M insert # keep emacs binds in insert mode
          fish_vi_key_bindings --no-erase insert
        '';
    };
  };

  programs.nix-index-database.comma.enable = true;
  home.sessionVariables.COMMA_PICKER = lib.getExe pkgs.fzf;

  programs.fzf = {
    enableBashIntegration = true;
    enableFishIntegration = true;
    changeDirWidgetCommand = "${fd} -H --type directory";
    fileWidgetCommand = "${fd} -H --type file";
    defaultCommand = "${fd} -H --type file";
    colors.bg = lib.mkForce "";
    defaultOptions = [ ];
  };

  programs.fd = {
    hidden = true;
    ignores = [
      ".git/"
      "*.bak"
    ];
    extraOptions = [ ];
  };
  programs.jujutsu = {
    settings = {
      user = {
        name = "Simon Yde";
        email = "git@simonyde.com";
      };
    };
  };

  home.packages = with pkgs; [
    git-crypt
    glab
  ];

  programs.gh = {
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.git = {
    userName = "Simon Yde";
    userEmail = "git@simonyde.com";
    aliases = {
      a = "add";
      br = "branch";
      cc = "commit -v";
      ci = "commit -a -v";
      co = "checkout";
      d = "diff";
      st = "status -s";

      ls = ''log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate'';
      ll = ''log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate --numstat'';

      filelog = "log -u";
      fl = "log -u";

      dl = "!git ll -1";

      dr = ''!f() { git diff "$1"^.."$1"; }; f'';

      fixup = "commit --fixup HEAD";
      fix = "rebase -i --autosquash";

      rhh = "reset --hard HEAD";
      alias = "config --get-regexp ^alias\\.";
    };
    extraConfig = {
      init.defaultBranch = "master";

      diff.colorMoved = "default";
      diff.algorithm = "histogram";
      merge.conflictStyle = "zdiff3";
      push = {
        default = "current";
        autoSetupRemote = true;
      };

      # Rebase
      branch.autosetuprebase = "always";
      pull.rebase = "merges";
      rebase.autostash = true;
      rebase.updateRefs = true;

      commit.verbose = true;
      rerere.enabled = true;

      column.ui = "auto";
      color.ui = "auto";

      branch.sort = "-committerdate";
      tag.sort = "-taggerdate";
      log.date = "iso";

      # Signing commits
      gpg.format = "ssh";
      commit.gpgsign = true;
      user.signingkey = "~/.ssh/id_ed25519.pub";

      fetch = {
        prune = true;
        recurseSubmodules = true;
      };

      # Submodules
      submodule.recurse = true;
      push.recurseSubmodules = false;
      status.submoduleSummary = true;
      diff.submodule = "log";

      url = {
        "ssh://git@codeberg.org/".insteadOf = "cb:";
        "ssh://git@github.com/".insteadOf = "gh:";
        "ssh://git@gitlab.com/".insteadOf = "gl:";
        "ssh://git@gitlab.au.dk/".insteadOf = "au:";
      };

    };
    ignores = [
      "**/.idea"
      "**/.metals"
      "**/_build"
      "**/elm-stuff"
      "**/node_modules"
      "**/target"
      "*.log"
      "*.sync-conflict*"
      ".direnv"
      ".env"
      ".envrc"
      "**/.mypy_cache"
      "**/__pycache__"
      "**/.ruff_cache"
      "**/.stfolder"
      "**/.stignore"
      ".vscode"
    ];
    difftastic = {
      enable = true;
      display = "inline";
    };
  };

  programs.ripgrep = {
    arguments = [
      "--smart-case"
      "--pretty"
      "--hidden"
      "--glob=!**/.git/*"
    ];
  };

  programs.zellij = {
    enableBashIntegration = false;
    enableFishIntegration = false;
  };

  xdg.configFile."zellij/layouts/compact_top.kdl".text = # kdl
    ''
      layout {
        pane size=1 borderless=true {
          plugin location="zellij:compact-bar"
        }
        children
      }
    '';

}

{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (lib) getExe mkIf;
  fd = getExe pkgs.fd;
  cfg = config.programs;
in

{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./neovim.nix
    ./yazi.nix
    ./starship.nix
    ./nushell.nix
  ];

  home = {
    shellAliases = {
      cat = mkIf cfg.bat.enable "bat";
      man = mkIf cfg.bat.enable "batman";
    };

    sessionVariables.COMMA_PICKER = mkIf cfg.fzf.enable "fzf";
  };

  programs = {
    nushell.shellAliases = {
      lt = mkIf cfg.eza.enable "eza --tree --level=2 --long --icons --git";
      cat = mkIf cfg.bat.enable "bat";
      man = mkIf cfg.bat.enable "batman";
    };

    atuin = {
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

    bat = {
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

    carapace = {
      enableFishIntegration = false;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };

    eza = {
      icons = "auto";
    };

    fish = {
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

    nix-index-database.comma.enable = true;
    fzf = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      changeDirWidgetCommand = "${fd} -H --type directory";
      fileWidgetCommand = "${fd} -H --type file";
      defaultCommand = "${fd} -H --type file";
      colors.bg = lib.mkForce "";
      defaultOptions = [ ];
    };

    fd = {
      hidden = true;
      ignores = [
        ".git/"
        "*.bak"
      ];
      extraOptions = [ ];
    };

    jujutsu = {
      settings = {
        user = {
          name = "Simon Yde";
          email = "git@simonyde.com";
        };
      };
    };

    gh = {
      settings = {
        git_protocol = "ssh";
      };
    };

    git = {
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

        diff = {
          colorMoved = "default";
          submodule = "log";
          algorithm = "histogram";
        };

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

    ripgrep = {
      arguments = [
        "--smart-case"
        "--pretty"
        "--hidden"
        "--glob=!**/.git/*"
      ];
    };

    zellij = {
      enableBashIntegration = false;
      enableFishIntegration = false;
    };
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

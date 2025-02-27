{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.programs.git;
in
{
  config = lib.mkIf cfg.enable {
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
    };

  };
}

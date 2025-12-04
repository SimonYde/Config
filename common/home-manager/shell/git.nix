_:

{
  programs.git = {
    settings = {

      user.name = "Simon Yde";
      user.email = "git@simonyde.com";

      alias = {
        a = "add";
        br = "branch";
        sw = "switch";

        cc = "commit -v";
        ca = "commit --all -v";

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
      init.defaultBranch = "master";

      merge.conflictStyle = "diff3";
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
      gpg.ssh.defaultKeyCommand = "ssh-add -L";
      commit.gpgsign = true;

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
      "result"
      "**/Session.vim"
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
      "**/.stversions"
      "**/.*stignore"
      ".vscode"
    ];
  };
}

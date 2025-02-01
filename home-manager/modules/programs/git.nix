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
    programs.git = {
      userName = "Simon Yde";
      userEmail = "git@simonyde.com";
      extraConfig = {
        init = {
          defaultBranch = "master";
        };
        pull = {
          rebase = false;
        };
        push = {
          autoSetupRemote = true;
        };
        merge = {
          conflictStyle = "diff3";
        };
        rebase = {
          updateRefs = true;
        };
        diff = {
          colorMoved = "default";
        };
        rerere = {
          enabled = true;
        };
        column.ui = "auto";
        branch.sort = "-committerdate";

        # Signing commits
        gpg.format = "ssh";
        commit.gpgsign = true;
        user.signingkey = "~/.ssh/id_ed25519.pub";
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
        "**/.ruff_cache"
        "**/.stfolder"
        "**/.stignore"
        ".vscode"
      ];
      delta = {
        enable = true;
        options = {
          dark = config.colorScheme.variant == "dark";
          navigate = true;
          line-numbers = true;
          side-by-side = true;
          features = builtins.concatStringsSep " " [
            "base16-stylix"
          ];
        };
      };
    };

    programs.gh = {
      settings = {
        git_protocol = "ssh";
      };
    };

    home.packages = with pkgs; [
      git-crypt
      glab
    ];
  };
}

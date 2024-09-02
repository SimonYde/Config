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
        "*.sync-conflict*"
        ".direnv"
        ".envrc"
        ".env"
        ".metals"
        ".idea"
        ".stignore"
        "*.log"
        ".stfolder"
        ".vscode"
        ".mypy_cache"
        ".ruff_cache"
        "**/_build"
        "**/target"
        "**/node_modules"
        "**/elm-stuff"
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

{ pkgs, ... }:

{
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
      merge = {
        conflictStyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
    ignores = [
      "*.sync-conflict*"
      ".direnv"
      ".stignore"
      ".stfolder"
      ".vscode"
      "**/_build"
      "**/target"
      "**/node_modules"
      "**/elm-stuff"
    ];
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        features = builtins.concatStringsSep " " [
          "line-numbers"
          "side-by-side"
          "Catppuccin"
        ];
      };
    };
  };

  home.packages = with pkgs; [
    git-crypt
  ];
}

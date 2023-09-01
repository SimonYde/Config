{ config, pkgs, ... }:

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
    };
    ignores = [
      "*.sync-conflict*"
      ".direnv"
      ".stignore"
      ".stfolder"
      ".vscode"
      "**/target"
      "**/node_modules"
      "**/elm-stuff"
    ];
  };

  home.packages = with pkgs; [
    git-crypt
  ];
}

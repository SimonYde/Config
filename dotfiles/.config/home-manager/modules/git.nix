{ config, pkgs, ... }:

{
  config.programs.git = {
    userName = "Simon Yde";
    userEmail = "git@simonyde.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = false;
      };
    };
    ignores = [
      "*.sync-conflict*"
      ".stignore"
      ".stfolder"
      ".vscode"
      "**/target"
      "**/node_modules"
    ];
  };
}

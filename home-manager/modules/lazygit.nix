{ pkgs, lib, config, ... }:

{
  programs.lazygit = {
    settings = {
      gui = {
      # use the mocha catppuccin theme
        theme = {
          lightTheme = false;
          activeBorderColor =  [ "#a6e3a1" "bold" ];# Green
          inactiveBorderColor =  [ "#cdd6f4" ];# Text
          optionsTextColor =  [ "#89b4fa" ];# Blue
          selectedLineBgColor =  [ "#313244" ];# Surface0
          selectedRangeBgColor =  [ "#313244" ];# Surface0
          cherryPickedCommitBgColor =  [ "#94e2d5" ];# Teal
          cherryPickedCommitFgColor =  [ "#89b4fa" ];# Blue
          unstagedChangesColor =  [ "red" ];# Red
        };
      };
    };
  };
}

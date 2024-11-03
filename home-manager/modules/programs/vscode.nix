{ lib, pkgs, ... }:
{
  programs.vscode = {
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      gruntfuggly.todo-tree
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-renderers
      ms-toolsai.jupyter-keymap

      github.copilot
      ms-python.python
      ms-python.vscode-pylance
      vspacecode.whichkey
    ];
  };
}

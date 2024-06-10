{ lib, pkgs, ... }:
{
  programs.vscode = {
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      asvetliakov.vscode-neovim
      gruntfuggly.todo-tree
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-renderers
      ms-toolsai.jupyter-keymap

      github.copilot
      ms-python.python
      ms-python.vscode-pylance
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "catppuccin-vsc-icons";
          publisher = "catppuccin";
          version = "0.23.0";
          sha256 = "sha256-zETZksec51Tq6mdXdJ110sn6NYIwN1roY3MBae1bWUU=";
        };
        meta = {
          description = "Soothing pastel icon theme for VSCode";
          license = lib.licenses.mit;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc-icons";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "whichkey";
          publisher = "VSpaceCode";
          version = "0.11.3";
          sha256 = "sha256-PnaOwOIcSo1Eff1wOtQPhoHYvrHDGTcsRy9mQfdBPX4=";
        };
        meta = {
          description = "This extension is aimed to provide the standalone which-key function in VScode for both users and extension to bundle.";
          license = lib.licenses.mit;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=VSpaceCode.whichkey";
        };
      })
    ];

    # userSettings = builtins.fromJSON (builtins.readFile ../../dotfiles/.config/Code/User/settings.json);
  };
}

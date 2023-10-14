{ lib, pkgs, ... }:

{
  programs.vscode = {
    package = pkgs.unstable.vscodium;
    extensions = with pkgs.unstable.vscode-extensions; [
      catppuccin.catppuccin-vsc
      asvetliakov.vscode-neovim
      gruntfuggly.todo-tree
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-renderers
      ms-toolsai.jupyter-keymap

      # Unfree
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
    ];


    # userSettings = builtins.fromJSON (builtins.readFile ../../dotfiles/.config/Code/User/settings.json);
  };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode-extension-github-copilot"
    "vscode-extension-MS-python-vscode-pylance"
  ];
}

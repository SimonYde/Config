{ pkgs, ... }:

{
	programs.vscode = {
		package = pkgs.unstable.vscodium;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      vscodevim.vim
      gruntfuggly.todo-tree
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-renderers
      ms-toolsai.jupyter-keymap

      # Unfree
      github.copilot
      ms-python.python
      ms-python.vscode-pylance
    ];
    # userSettings = builtins.fromJSON (builtins.readFile ../../dotfiles/.config/Code/User/settings.json);
	};
}

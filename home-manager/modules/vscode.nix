{ pkgs, ... }:

{
	programs.vscode = {
		package = pkgs.unstable.vscodium;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      vscodevim.vim
      gruntfuggly.todo-tree
      ms-python.python
      ms-python.vscode-pylance
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-renderers
      ms-toolsai.jupyter-keymap
    ];
    # userSettings = builtins.fromJSON (builtins.readFile ../../dotfiles/.config/Code/User/settings.json);
	};
}

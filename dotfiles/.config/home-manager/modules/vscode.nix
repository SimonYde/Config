{ pkgs, ... }:

{
	programs.vscode = {
		package = pkgs.unstable.vscode;
	};
}

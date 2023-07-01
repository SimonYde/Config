{pkgs, inputs, ... }:

{
	programs.vscode = {
		package = pkgs.unstable.vscode;
	};
  

}

{ pkgs, config, lib, ...}:

{
  programs.bat = {
    config = {
      theme = "Catppuccin-mocha";
    };
    themes = {
      Catppuccin-mocha = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat"; 
        rev = "ba4d168";
        sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
      } + "/Catppuccin-mocha.tmTheme");
    };
  };
}

{ pkgs,  ... }:

{
  programs.fish = {
    shellAliases = {
      cat = "bat";
      ls = "exa";
      sudo = "doas";
    };
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
    '';
    # shellInit = ''
    # '';
  };
}

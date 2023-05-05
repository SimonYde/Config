{ pkgs,  ... }:

{
  programs.fish = {
    shellAliases = {
      cat = "bat";
      ls = "exa";
      sudo = "doas";
    };
    loginShellInit = ''
      any-nix-shell fish --info-right | source
    '';
    # shellInit = ''
    # '';
  };
}

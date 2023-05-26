{ pkgs,  ... }:

{
  programs.fish = {
    shellAliases = {
      cat = "bat";
      sudo = "doas";
    };
    shellInit = ''
      any-nix-shell fish --info-right | source
    '';
    # shellInit = ''
    # '';
  };
}

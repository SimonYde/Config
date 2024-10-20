{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  nix-colors = inputs.nix-colors;
  cfg = config.syde.theming;
in
{
  imports = [ ./module.nix ];

  config = mkIf cfg.enable {
    colorScheme = nix-colors.colorSchemes."gruvbox-dark-hard";

    syde.theming.fonts = {
      monospace = {
        name = "JetBrains Mono Nerd Font Mono";
        package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
      };
      sansSerif = {
        name = "JetBrains Mono Nerd Font Propo";
        package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
      };
      serif = {
        name = "Gentium Plus";
        package = pkgs.gentium;
      };
      packages = [
        pkgs.newcomputermodern
        pkgs.gentium
        pkgs.source-sans-pro
        pkgs.roboto
        pkgs.font-awesome
        pkgs.libertinus
      ];
    };
  };
}

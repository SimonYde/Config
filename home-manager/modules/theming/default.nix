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
        name = "JetBrainsMono Nerd Font Mono";
        package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
      };
      sansSerif = {
        name = "JetBrainsMono Nerd Font Propo";
        package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
      };
      serif = {
        name = "Gentium Plus";
        package = pkgs.gentium;
      };
      packages = with pkgs; [
        font-awesome
        gentium
        libertinus
        newcomputermodern
        roboto
        source-sans-pro
      ];
    };
  };
}

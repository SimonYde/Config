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
  scheme = nix-colors.colorSchemes."gruvbox-dark-hard";
  cfg = config.syde.theming;
in
{
  imports = [ ./module.nix ];

  config = mkIf cfg.enable {
    colorScheme = scheme // {
      palette = scheme.palette // {
        base00 = "1b1b1b";
      };
    };

    syde.theming.fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sansSerif = {
        name = "JetBrainsMono Nerd Font Propo";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      serif = {
        name = "Gentium Plus";
        package = pkgs.gentium;
      };
      packages = with pkgs; [
        font-awesome
        gentium
        atkinson-hyperlegible
        atkinson-monolegible
        libertinus
        newcomputermodern
        roboto
        source-sans-pro
      ];
    };
  };
}

{ inputs, lib, config, pkgs, ... }:
let
  nix-colors = inputs.nix-colors;
  cfg = config.themes;
in
{
  imports = [
    nix-colors.homeManagerModules.default
  ];

  config.colorScheme = nix-colors.colorSchemes."catppuccin-${cfg.flavour}";

  options.themes = {
    flavour = lib.mkOption {
      type    = lib.types.str;
      default = if config.themes.prefer-dark then "mocha" else "latte";
    };
    prefer-dark = lib.mkOption {
      type    = lib.types.bool;
      default = true;
    };
    gtk = {
      darkTheme = lib.mkOption {
        type    = lib.types.str;
        default = "Catppuccin-Mocha-Compact-Lavender-Dark";
      };
      lightTheme = lib.mkOption {
        type    = lib.types.str;
        default = "Catppuccin-Latte-Compact-Lavender-Light";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.catppuccin-gtk.override {
          accents = [ "lavender" ];
          size    = "compact";
          tweaks  = [ "rimless" ];
          variant = cfg.flavour;
        };
      };
    };
    cursorTheme = {
      name = lib.mkOption {
        type    = lib.types.str;
        default = "Catppuccin-Mocha-Dark-Cursors";
      };
      package = lib.mkOption {
        type    = lib.types.package;
        default = pkgs.catppuccin-cursors.mochaDark;
      };
    };
  };
}

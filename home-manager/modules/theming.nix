{ inputs, lib, config, pkgs, ... }:
let
  nix-colors = inputs.nix-colors;
  nix-colors-lib = nix-colors.lib.contrib { inherit pkgs; };
  slug = config.colorScheme.slug;
  gtk-package =
    # if slug == "catppuccin-mocha" || slug == "catppuccin-latte"
    # then
    #   pkgs.catppuccin-gtk.override
    #     {
    #       accents = [ "lavender" ];
    #       size = "compact";
    #       tweaks = [ "rimless" ];
    #       variant = cfg.flavour;
    #     } else
    nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
  gtk-theme =
    if config.colorScheme.slug == "catppuccin-mocha" then "Catppuccin-Mocha-Compact-Lavender-Dark"
    else if config.colorScheme.slug == "catppuccin-latte" then "Catppuccin-Latte-Compact-Lavender-Light"
    else config.colorScheme.slug;
  cfg = config.syde.theming;
in
{
  imports = [
    nix-colors.homeManagerModules.default
  ];

  config.colorScheme = nix-colors.colorSchemes."catppuccin-mocha";

  options.syde.theming = {
    flavour = lib.mkOption {
      type = lib.types.str;
      default = if cfg.prefer-dark then "mocha" else "latte";
    };
    prefer-dark = lib.mkOption {
      type = lib.types.bool;
      default = config.colorScheme.variant == "dark";
    };
    gtk = {
      darkTheme = lib.mkOption {
        type = lib.types.str;
        default = gtk-theme;
      };
      lightTheme = lib.mkOption {
        type = lib.types.str;
        default = gtk-theme;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = gtk-package;
      };
    };
    cursorTheme = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Catppuccin-Mocha-Dark-Cursors";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.catppuccin-cursors.mochaDark;
      };
    };
  };
}

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  mkUpper =
    str: with builtins; (lib.toUpper (substring 0 1 str)) + (substring 1 (stringLength str) str);
  nix-colors = inputs.nix-colors;
  nix-colors-lib = nix-colors.lib.contrib { inherit pkgs; };
  nix-colors-gtk = nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
  slug = config.colorScheme.slug;

  accent = "lavender";
  size = "compact";
  accentUpper = mkUpper accent;
  sizeUpper = mkUpper size;
  flavourUpper = mkUpper cfg.flavour;
  variantUpper = mkUpper config.colorScheme.variant;

  gtk-package = pkgs.catppuccin-gtk.override {
    accents = [ accent ];
    inherit size;
    tweaks = [ "rimless" ];
    variant = cfg.flavour;
  };
  gtk-theme = "Catppuccin-${flavourUpper}-${sizeUpper}-${accentUpper}-${variantUpper}";
  cfg = config.syde.theming;
in
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    nix-colors.homeManagerModules.default
  ];

  config = {
    colorScheme = nix-colors.colorSchemes."catppuccin-mocha";
    catppuccin.flavour = cfg.flavour;

    syde.theming = {
      gtk.package = gtk-package;
      gtk.theme = gtk-theme;
    };

    programs = {
      git.delta.catppuccin.enable = true;
      bat.catppuccin.enable = true;
      imv.catppuccin.enable = true;
      btop.catppuccin.enable = true;
      mpv.catppuccin.enable = true;
      starship.catppuccin.enable = true;
    };
  };

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
      theme = lib.mkOption {
        type = lib.types.str;
        default = slug;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = nix-colors-gtk;
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

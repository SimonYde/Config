{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    splitString
    stringLength
    toUpper
    types
    ;
  inherit (builtins) head mapAttrs substring;
  mkCapitalised = str: (toUpper (substring 0 1 str)) + (substring 1 (stringLength str) str);
  nix-colors = inputs.nix-colors;
  nix-colors-lib = nix-colors.lib.contrib { inherit pkgs; };
  nix-colors-gtk = nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
  slug = config.colorScheme.slug;
  is_catppuccin = (head (splitString "-" slug)) == "catppuccin";

  accent = "lavender";
  size = "compact";
  accentUpper = mkCapitalised accent;
  sizeUpper = mkCapitalised size;
  flavourUpper = mkCapitalised cfg.flavour;
  variantUpper = mkCapitalised config.colorScheme.variant;

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
    nix-colors.homeManagerModules.default
    ./qt.nix
    ./gtk.nix
    ./stylix.nix
  ];

  config = mkIf cfg.enable {
    colorScheme = nix-colors.colorSchemes."catppuccin-mocha";

    gtk.enable = true;
    qt.enable = true;

    syde.theming = mkIf is_catppuccin {
      gtk.package = gtk-package;
      gtk.theme = gtk-theme;
    };
  };

  options.syde.theming = {
    enable = mkEnableOption "Personal rice";
    palette-hex = mkOption {
      type = types.attrsOf types.str;
      default = mapAttrs (name: value: "#" + value) config.colorScheme.palette;
    };
    flavour = mkOption {
      type = types.str;
      default = if cfg.prefer-dark then "mocha" else "latte";
    };
    prefer-dark = mkOption {
      type = types.bool;
      default = config.colorScheme.variant == "dark";
    };
    gtk = {
      theme = mkOption {
        type = types.str;
        default = slug;
      };
      package = mkOption {
        type = types.package;
        default = nix-colors-gtk;
      };
    };
    cursorTheme = {
      name = mkOption {
        type = types.str;
        default = "Catppuccin-Mocha-Dark-Cursors";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.catppuccin-cursors.mochaDark;
      };
    };
  };
}

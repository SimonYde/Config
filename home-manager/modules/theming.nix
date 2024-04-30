{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    head
    mapAttrs
    mkIf
    mkOption
    mkEnableOption
    splitString
    stringLength
    substring
    toUpper
    types
    ;
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
    inputs.catppuccin.homeManagerModules.catppuccin
    nix-colors.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    colorScheme = nix-colors.colorSchemes."catppuccin-mocha";
    catppuccin.flavour = cfg.flavour;

    gtk.enable = true;
    qt.enable = true;

    syde.theming = mkIf is_catppuccin {
      gtk.package = gtk-package;
      gtk.theme = gtk-theme;
    };
    home.pointerCursor = {
      name = cfg.cursorTheme.name;
      package = cfg.cursorTheme.package;
      size = 24;
      gtk.enable = config.gtk.enable;
    };

    programs = mkIf is_catppuccin {
      git.delta.catppuccin.enable = true;
      bat.catppuccin.enable = true;
      imv.catppuccin.enable = true;
      btop.catppuccin.enable = true;
      mpv.catppuccin.enable = true;
    };
  };

  options.syde.theming = {
    enable = mkEnableOption "Personal rice";
    palette_with_hex = mkOption {
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

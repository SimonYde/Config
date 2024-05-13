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
    inputs.catppuccin.homeManagerModules.catppuccin
    nix-colors.homeManagerModules.default
    ./qt.nix
    ./gtk.nix
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

    programs = mkIf is_catppuccin { git.delta.catppuccin.enable = false; };
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

  # {
  #   base00 = "#1d2021";
  #   base01 = "#3c3836";
  #   base02 = "#504945";
  #   base03 = "#665c54";
  #   base04 = "#bdae93";
  #   base05 = "#d5c4a1";
  #   base06 = "#ebdbb2";
  #   base07 = "#fbf1c7";
  #   base08 = "#fb4934";
  #   base09 = "#fe8019";
  #   base0A = "#fabd2f";
  #   base0B = "#b8bb26";
  #   base0C = "#8ec07c";
  #   base0D = "#83a598";
  #   base0E = "#d3869b";
  #   base0F = "#d65d0e";
  # }

#   [Scheme]
# Name=gruvbox dark hard
# ColorForeground=#ebdbb2
# ColorBackground=#1d2021
# ColorPalette=#282828;#cc241d;#98971a;#d79921;#458588;#b16286;#689d6a;#a89984;#928374;#fb4934;#b8bb26;#fabd2f;#83a598;#d3869b;#8ec07c;#ebdbb2
# TabActivityColor=#bf4040

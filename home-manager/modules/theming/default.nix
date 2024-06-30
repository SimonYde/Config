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
    mkForce
    mkDefault
    ;
  inherit (builtins) head mapAttrs substring;
  mkCapitalised = str: (toUpper (substring 0 1 str)) + (substring 1 (stringLength str) str);
  nix-colors = inputs.nix-colors;
  nix-colors-lib = nix-colors.lib.contrib { inherit pkgs; };
  nix-colors-gtk = nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
  slug = config.colorScheme.slug;

  accent = "lavender";
  size = "compact";
  flavour = if cfg.prefer-dark then "mocha" else "latte";
  accentUpper = mkCapitalised accent;
  sizeUpper = mkCapitalised size;
  flavourUpper = mkCapitalised flavour;
  variantUpper = mkCapitalised config.colorScheme.variant;

  catppuccin-gtk-package = pkgs.catppuccin-gtk.override {
    accents = [ accent ];
    inherit size;
    tweaks = [ "rimless" ];
    variant = flavour;
  };
  catppuccin-gtk-theme = "Catppuccin-${flavourUpper}-${sizeUpper}-${accentUpper}-${variantUpper}";
  is_catppuccin = (head (splitString "-" slug)) == "catppuccin";

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

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ cfg.fonts.monospace.name ];
        serif = [ cfg.fonts.serif.name ];
        sansSerif = [ cfg.fonts.sansSerif.name ];
        emoji = [ cfg.fonts.emoji.name ];
      };
    };

    home.packages = cfg.fonts.packages;
    gtk.enable = true;
    qt.enable = true;

    home.sessionVariables = {
      # NOTE: hardcoded path
      BACKGROUND_DIR = "$HOME/Config/assets/backgrounds/${slug}";
    };

    home.pointerCursor = mkDefault {
      package = cfg.cursor.package;
      name = cfg.cursor.name;
      size = 24;
      gtk.enable = true;
    };

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
        cfg.fonts.monospace.package
        cfg.fonts.serif.package
        cfg.fonts.sansSerif.package
        cfg.fonts.emoji.package
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        pkgs.gentium
        pkgs.source-sans-pro
        pkgs.roboto
        pkgs.font-awesome
        pkgs.libertinus
      ];
    };

    programs.neovim.plugins = with pkgs.vimPlugins; mkIf is_catppuccin [ catppuccin-nvim ];
  };

  options.syde.theming = {
    enable = mkEnableOption "Personal rice";
    palette-hex = mkOption {
      type = types.attrsOf types.str;
      default = mapAttrs (name: value: "#" + value) config.colorScheme.palette;
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
    cursor = {
      name = mkOption {
        type = types.str;
        default = "catppuccin-mocha-dark-cursors";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.catppuccin-cursors.mochaDark;
      };
    };
    fonts =
      let
        fontType = types.submodule {
          options = {
            package = mkOption {
              description = "Package providing the font.";
              type = types.package;
            };
            name = mkOption {
              description = "Name of the font within the package.";
              type = types.str;
            };
          };
        };
      in
      {
        monospace = mkOption {
          description = "Monospace font.";
          type = fontType;
          default = {
            name = "DejaVu Sans Mono";
            package = pkgs.dejavu_fonts;
          };
        };
        serif = mkOption {
          description = "Serif font.";
          type = fontType;
          default = {
            name = "DejaVu Serif";
            package = pkgs.dejavu_fonts;
          };
        };

        sansSerif = mkOption {
          description = "Sans-serif font.";
          type = fontType;
          default = {
            name = "DejaVu Sans";
            package = pkgs.dejavu_fonts;
          };
        };

        emoji = mkOption {
          description = "Emoji font.";
          type = fontType;
          default = {
            name = "Noto Color Emoji";
            package = pkgs.noto-fonts-emoji;
          };
        };
        packages = mkOption {
          description = "Additional font packages.";
          type = types.listOf types.package;
          default = [ ];
        };
      };
  };
}

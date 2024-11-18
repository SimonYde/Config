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
    types
    mkDefault
    strings
    ;
  inherit (builtins) mapAttrs;
  nix-colors = inputs.nix-colors;
  colorScheme = config.colorScheme;
  hexToRGBString = nix-colors.lib.conversions.hexToRGBString ",";
  slug = colorScheme.slug;

  cfg = config.syde.theming;
in
{
  imports = [
    nix-colors.homeManagerModules.default
    ./stylix.nix
  ];

  config = mkIf cfg.enable {
    gtk.enable = true;
    gtk = {
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      };
      iconTheme = {
        name = if cfg.prefer-dark then "Papirus-Dark" else "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      theme = lib.mkDefault {
        name = cfg.gtk.theme;
        package = cfg.gtk.package;
      };
      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = cfg.prefer-dark;
        };
      };
      gtk4 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = cfg.prefer-dark;
        };
      };
    };

    home.sessionVariables = {
      GTK_THEME = config.gtk.theme.name;
    };

    qt = {
      enable = true;
      platformTheme.name = lib.mkDefault "gtk3";
    };

    home.pointerCursor = mkDefault {
      package = cfg.cursor.package;
      name = cfg.cursor.name;
      size = 24;
      gtk.enable = true;
    };

    syde.theming.fonts = {
      packages = [
        cfg.fonts.monospace.package
        cfg.fonts.serif.package
        cfg.fonts.sansSerif.package
        cfg.fonts.emoji.package
      ];
    };

    home.packages = cfg.fonts.packages;

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ cfg.fonts.monospace.name ];
        serif = [ cfg.fonts.serif.name ];
        sansSerif = [ cfg.fonts.sansSerif.name ];
        emoji = [ cfg.fonts.emoji.name ];
      };
    };

    programs.neovim.plugins = mkIf (strings.hasPrefix "catppuccin" slug) [
      pkgs.vimPlugins.catppuccin-nvim
    ];
    syde.theming.cursor = mkIf (strings.hasPrefix "catppuccin" slug) {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
    };
  };

  options.syde.theming = {
    enable = mkEnableOption "Personal rice";
    palette-hex = mkOption {
      type = types.attrsOf types.str;
      default = mapAttrs (name: value: "#" + value) config.colorScheme.palette;
    };
    palette-rgb = mkOption {
      description = "base16 palette as comma separated rgb string";
      type = types.attrsOf types.str;
      default = mapAttrs (name: value: hexToRGBString value) config.colorScheme.palette;
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
        default = pkgs.adw-gtk3;
      };
    };
    cursor = {
      name = mkOption {
        type = types.str;
        default = "volantes_cursors";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.volantes-cursors;
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

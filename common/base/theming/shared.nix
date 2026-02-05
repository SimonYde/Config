{
  config,
  inputs,
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    image = null;
    polarity = config.lib.stylix.colors.variant;
    base16Scheme = "${inputs.tinted-schemes}/base24/catppuccin-mocha.yaml";
    override = {
      base00 = "181825"; # mantle instead of base
      base01 = "11111b"; # crust instead of mantle
    };

    # cursor = {
    #   name = "catppuccin-mocha-dark-cursors";
    #   package = pkgs.catppuccin-cursors.mochaDark;
    #   size = 24;
    # };

    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "Breeze_Light";
      size = 32;
    };

    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };

      sansSerif = {
        name = "JetBrainsMono Nerd Font Propo";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };

      serif = {
        name = "Gentium";
        package = pkgs.gentium;
      };

      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };

      sizes = {
        terminal = 11;
        popups = 13;
      };
    };

    opacity = {
      terminal = 1.0;
      applications = 1.0;
      popups = 1.0;
    };
  };
}

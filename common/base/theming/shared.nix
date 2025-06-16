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
    };

    cursor = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
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
        name = "Gentium Plus";
        package = pkgs.gentium;
      };

      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji;
      };

      sizes = {
        terminal = 11;
        popups = 13;
      };
    };

    opacity = {
      terminal = 0.9;
      popups = 0.85;
    };
  };
}

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
      name = "volantes_cursors";
      package = pkgs.volantes-cursors;
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
        terminal = 11.5;
        popups = 13;
      };
    };

    opacity = {
      terminal = 1.0;
      popups = 1.0;
    };
  };
}

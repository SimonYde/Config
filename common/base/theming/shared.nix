{
  config,
  inputs,
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    image = config.lib.stylix.pixel "base00";
    base16Scheme = "${inputs.tinted-schemes}/base16/gruvbox-dark-hard.yaml";
    override = {
      base00 = "1b1b1b";
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
      terminal = 0.85;
      popups = 0.70;
    };
  };
}

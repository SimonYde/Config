{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.syde.fonts;
in {
  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      #----Fonts----
      source-sans-pro
      roboto
      font-awesome
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "FiraCode"
        ];
      })
      gentium
      libertinus
    ];
  };

  options.syde.fonts = {
    enable = lib.mkEnableOption "font config";
  };
}

{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.syde.programming.latex.enable {
    home.packages = with pkgs; [
      texlab
      tectonic
      harper
    ];
  };

  options.syde.programming.latex = {
    enable = lib.mkEnableOption "Latex";
  };
}

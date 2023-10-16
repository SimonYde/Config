{ pkgs, config, lib, ... }:

{
  config = lib.mkIf config.syde.programming.latex.enable {
    home.packages = with pkgs; [
      texlab
      tectonic
      ltex-ls
    ];
  };
  options.syde.programming.latex = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
}

{lib, pkgs, options, config, ...}:

let
cfg = config.syde.programming.bash;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ bash-language-server ];
  };

  options.syde.programming.bash = {
    enable = lib.mkEnableOption "lua language tools";
  };
}
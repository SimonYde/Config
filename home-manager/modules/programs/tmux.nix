{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.tmux;
in
{
  config = lib.mkIf cfg.enable {
    programs.tmux = {
      clock24 = true;
      baseIndex = 1;
      prefix = "C-l";
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
      ];
    };
  };
}

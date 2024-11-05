{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.tmux;
  terminal = config.syde.terminal.emulator;
in
{
  config = lib.mkIf cfg.enable {
    programs.fzf.tmux.enableShellIntegration = true;
    programs.tmux = {
      clock24 = true;
      baseIndex = 1;
      prefix = "C-l";
      terminal = terminal;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restorn 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
      ];
      extraConfig = ''
        set -g status-position top
      '';
    };
  };
}

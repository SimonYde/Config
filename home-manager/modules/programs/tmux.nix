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
          extraConfig = # tmux
            "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = continuum;
          extraConfig = # tmux
            ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '60' # minutes
            '';
        }
      ];
      extraConfig = # tmux
        ''
          # For Image.nvim
          set -gq allow-passthrough on
          set -g visual-activity off

          set -g status-position top
          set -sg escape-time 5
          set-option -g terminal-overrides 'xterm-256color:RGB'
          set -ga update-environment TERM
          set -ga update-environment TERM_PROGRAM
        '';
    };
  };
}

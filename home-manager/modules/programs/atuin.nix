{ config, lib, ... }:

let cfg = config.programs.atuin; in
{
  config = lib.mkIf cfg.enable {
    programs.atuin = {
      flags = [
        # "--disable-up-arrow"
      ];
      settings = {
        auto_sync = false;
        history_filter = [
          "fg *"
          "pkill *"
          "kill *"
          "rm *"
          "rmdir *"
          "mkdir *"
          "touch *"
        ];
        filter_mode_shell_up_key_binding = "session";
      };
    };
  };
}

{ config, lib, ... }:

let cfg = config.programs.atuin; in
{
  config = lib.mkIf cfg.enable {
    programs.atuin = {
      flags = [
        "--disable-up-arrow"
      ];
      settings = {
        auto_sync = false;
      };
    };
  };
}

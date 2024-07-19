{ config, lib, ... }:

let
  cfg = config.programs.fd;
in
{
  config = lib.mkIf cfg.enable {
    programs.fd = {
      hidden = true;
      ignores = [
        ".git/"
        "*.bak"
      ];
      extraOptions = [ ];
    };
  };
}

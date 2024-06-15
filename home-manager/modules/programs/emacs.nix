{config, lib, ...}:

let
cfg = config.programs.emacs;
in
{
  config = lib.mkIf cfg.enable {
    programs.emacs = {

    };
    services.emacs = {
      enable = true;
    };
  };
}

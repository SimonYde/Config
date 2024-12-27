{
  config,
  lib,
  ...
}:

let
  cfg = config.programs.jujutsu;
in
{
  config = lib.mkIf cfg.enable {
    programs.jujutsu = {
      settings = {
        user = {
          name = "Simon Yde";
          email = "git@simonyde.com";
        };
      };
    };
  };
}

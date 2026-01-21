{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.programs.voxtype;
in
{
  config = lib.mkIf cfg.enable {
    programs.voxtype = {
      package = inputs.voxtype.packages.${pkgs.stdenv.hostPlatform.system}.vulkan;
      model.name = "base.en";
      service.enable = true;
      settings = (fromTOML (builtins.readFile ./voxtype-default.toml)) // {
        hotkey.enabled = false;
        whisper.language = "en";
      };
    };
  };
}

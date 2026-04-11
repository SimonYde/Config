{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.syde.cft;
in

{
  options.syde.cft = { };

  config = {
    home.packages = with pkgs; [

      (cutter.withPlugins (plugins: with plugins; [
        rz-ghidra
      ]))

    ];

    programs.rizin.enable = true;
  };
}

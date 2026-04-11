{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.syde.ctf;
in

{
  options.syde.ctf = { };

  config = {
    home.packages = with pkgs; [

      (cutter.withPlugins (plugins: with plugins; [
        rz-ghidra
      ]))

    ];

    programs.rizin.enable = true;
  };
}

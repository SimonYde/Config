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
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (cutter.withPlugins (plugins: with plugins; [
        rz-ghidra
      ]))

    ];

    programs.rizin.enable = true;
  };

  options.syde.cft = {
    enable = lib.mkEnableOption "CFT tools";
  };
}

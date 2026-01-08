{
  pkgs,
  lib,
  username,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.syde.audio-production;
in
{
  options.syde.audio-production = {
    enable = lib.mkEnableOption "Audio Production configuration";
  };

  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  config = mkIf cfg.enable {
    home-manager.users.${username}.imports = [ ../home-manager/audio-production.nix ];

    musnix = {
      enable = true;
      kernel.realtime = true;
      kernel.packages = pkgs.cachyosKernels.linuxPackages-cachyos-rt-bore-lto;
    };

    users.users.${username}.extraGroups = [ "audio" ];
  };
}

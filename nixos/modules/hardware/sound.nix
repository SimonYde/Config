{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.syde.sound;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qjackctl
      qpwgraph
    ];
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

  };
  options.syde.sound = {
    enable = lib.mkEnableOption "sound configuration";
  };
}

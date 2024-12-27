{ config, lib, ... }:
let
  cfg = config.syde.sound;
in
{
  config = lib.mkIf cfg.enable {
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      # wireplumber.extraConfig = {
      #   "jbl-reflect-aero" = {
      #     "monitor.bluez.rules" = [
      #       {
      #         matches = [
      #           {
      #             # Match any bluetooth device with ids equal to that of a WH-1000XM3
      #             "device.name" = "bluez_input.68:D6:ED:BD:E6:E6";
      #           }
      #         ];
      #         actions = {
      #           update-props = {
      #             "device.disabled" = true;
      #           };
      #         };
      #       }
      #     ];
      #   };
      # };
    };

  };
  options.syde.sound = {
    enable = lib.mkEnableOption "sound configuration";
  };
}

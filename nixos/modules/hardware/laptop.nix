{ lib, config, ... }:

let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.syde.laptop;
in
{
  config = mkIf cfg.enable {
    hardware.nvidia = {
      powerManagement.enable = true;
      powerManagement.finegrained = true;
    };

    services.libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
        middleEmulation = true;
        tapping = true;
      };
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = false;
  };

  options.syde.laptop = {
    enable = mkEnableOption "laptop hardware configuration.";
  };
}

{ lib, config, ... }:

let
  inherit (lib)
    mkIf
    mkForce
    mkEnableOption
    ;
  cfg = config.syde.laptop;
in
{
  config = mkIf cfg.enable {
    powerManagement = {
      powertop.enable = false;
    };

    hardware.nvidia = {
      powerManagement.enable = mkForce true;
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

    programs.light.enable = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = false;
  };

  options.syde.laptop = {
    enable = mkEnableOption "laptop hardware configuration.";
  };
}

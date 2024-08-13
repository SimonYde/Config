{ lib, config, ... }:

let
  inherit (lib)
    mkIf
    mkForce
    mkDefault
    mkEnableOption
    ;
in
{
  config = mkIf config.syde.laptop.enable {
    powerManagement = {
      cpuFreqGovernor = mkDefault "powersave";
      powertop.enable = false;
    };

    hardware.nvidia = {
      powerManagement.enable = mkForce true;
      powerManagement.finegrained = mkForce true;
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

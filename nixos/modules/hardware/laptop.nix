{ lib, config, ... }:
{
  config = lib.mkIf config.syde.laptop.enable {
    powerManagement = {
      cpuFreqGovernor = lib.mkDefault "powersave";
      powertop.enable = false;
    };

    services.xserver.libinput = {
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
    services.blueman.enable = true;
  };

  options.syde.laptop = {
    enable = lib.mkEnableOption "laptop hardware configuration.";
  };
}

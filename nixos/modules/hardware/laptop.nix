{ lib, ... }:

{
  powerManagement = {
    cpuFreqGovernor = lib.mkDefault "powersave";
    powertop.enable = true;
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
}

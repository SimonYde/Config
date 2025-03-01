{ lib, config, ... }:

let
  inherit (lib) mkIf mkDefault mkEnableOption;
  cfg = config.syde.laptop;
in
{
  config = mkIf cfg.enable {
    # services.libinput = {
    #   enable = true;
    #   touchpad = {
    #     disableWhileTyping = true;
    #     naturalScrolling = true;
    #     middleEmulation = true;
    #     tapping = true;
    #   };
    # };

    powerManagement.cpuFreqGovernor = "powersave";

    hardware = {
      bluetooth = {
        enable = mkDefault true;
        powerOnBoot = mkDefault false;
      };

      nvidia = {
        powerManagement.enable = true;
        powerManagement.finegrained = true;
      };
    };
  };

  options.syde.laptop = {
    enable = mkEnableOption "laptop hardware configuration.";
  };
}

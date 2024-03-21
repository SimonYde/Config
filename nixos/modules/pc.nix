{ pkgs, lib, config, ... }:

let
  cfg = config.syde.pc;
in
{
  config = lib.mkIf cfg.enable {
    system.stateVersion = "23.11";
    time.timeZone = "Europe/Copenhagen";

    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
      LC_MONETARY = "da_DK.UTF-8";
      LC_NAME = "da_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";
      LC_TIME = "da_DK.UTF-8";
    };

    services.xserver = {
      xkb.layout = "us(colemak_dh),dk";
      xkb.options = "caps:escape,grp:rctrl_toggle";
      excludePackages = [ pkgs.xterm ];
    };

    console.useXkbConfig = true;

    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [
          80 # HTTP
          443 # HTTPS
        ];
      };
      useDHCP = lib.mkDefault true;
      networkmanager = {
        enable = true;
        wifi.powersave = false;
      };
    };

    users.users.${config.syde.user} = {
      isNormalUser = true;
      description = "Simon Yde";
      shell = pkgs.${config.syde.shell};
      extraGroups = [ "video" "networkmanager" "wheel" ];
    };

    programs.${config.syde.shell}.enable = true;

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
      gentium
      libertinus
    ];

    environment.systemPackages = with pkgs; [
      git
      alacritty
    ];

    services.udisks2.enable = true;

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
    boot.supportedFilesystems = [ "ntfs" ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };

    syde.sound.enable = lib.mkDefault true;
  };

  options.syde.pc = {
    enable = lib.mkEnableOption "PC configuration";
  };
}

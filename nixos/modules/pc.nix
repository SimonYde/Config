{ config, pkgs, lib, ...}:

{
  system.stateVersion = "23.05";
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
    layout = "eu";
    # xkbVariant = "eurkey-cmk-dh-ansi";
    xkbOptions = "caps:escape";
  };  

  networking = {
    firewall.enable = true;
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  users.users.syde = {
    isNormalUser = true;
    description = "Simon Yde";
    extraGroups = [ "video" "networkmanager" "wheel" ];
  };
  
  fonts.fonts = with pkgs; [
    nerdfonts
    font-awesome
    gentium 
    libertinus
  ];
  
  environment.systemPackages = with pkgs; [
    git alacritty 
  ];

  programs.command-not-found.enable = true;
  
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
  boot.supportedFilesystems = [ "ntfs" ];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  imports = [
    ../modules/hardware/filesystems.nix
    ../modules/programs/nix.nix
    ../modules/programs/doas.nix
    ../modules/services/systemd-boot.nix
    ../modules/services/sound.nix
  ];
}

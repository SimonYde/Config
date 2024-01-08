{ pkgs, lib, ...}:

{
  system.stateVersion = "23.11";
  time.timeZone = "Europe/Copenhagen";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT    = "da_DK.UTF-8";
    LC_MONETARY       = "da_DK.UTF-8";
    LC_NAME           = "da_DK.UTF-8";
    LC_NUMERIC        = "da_DK.UTF-8";
    LC_PAPER          = "da_DK.UTF-8";
    LC_TELEPHONE      = "da_DK.UTF-8";
    LC_TIME           = "da_DK.UTF-8";
  };

  services.xserver = {
    layout = "us(colemak_dh),dk";
    # xkbVariant = "";
    xkbOptions = "caps:escape,grp:rctrl_toggle";
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

  users.users.syde = {
    isNormalUser = true;
    description = "Simon Yde";
    shell = pkgs.fish;
    extraGroups = [ "syncthing" "video" "networkmanager" "wheel" ];
  };

  programs.fish.enable = true;

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

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  imports = [
    ../modules/programs/nix.nix
    ../modules/programs/cachix.nix
    ../modules/programs/doas.nix
    ../modules/services/systemd-boot.nix
    ../modules/services/syncthing.nix
    ../modules/services/ssh.nix
    ../modules/hardware/sound.nix
    ../modules/hardware/filesystems.nix
  ];
}

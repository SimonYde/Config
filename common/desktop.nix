{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (lib) mkDefault mkIf;
  inherit (config.syde) user;
in
{

  imports = [
    ./base/theming/nixos.nix
    ./nixos
    inputs.stylix.nixosModules.stylix
  ];

  home-manager.users.${user}.imports = [ ./home-manager/gui ];

  boot = {
    plymouth.enable = true;
    consoleLogLevel = 3;
    kernelParams = [ "quiet" ];

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
    ];

    supportedFilesystems = [ "ntfs" ];

    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  environment.systemPackages =
    with pkgs;
    [
      git
      helvum
    ]
    ++ lib.optionals config.services.ratbagd.enable [
      piper
    ];

  programs.wireshark.package = pkgs.wireshark;

  users.users.${user}.extraGroups = [
    (mkIf config.programs.wireshark.enable "wireshark")
  ];

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

  console = {
    useXkbConfig = true;
    font = mkDefault "ter-i24b";
    packages = [ pkgs.terminus_font ];
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
      ];
    };
    useDHCP = mkDefault true;
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        macAddress = "random";
      };
    };
  };

  hardware = {
    bluetooth.enable = mkDefault true;
    steam-hardware.enable = true;
    uinput.enable = true;

    enableAllHardware = true;

    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  services = {
    udisks2.enable = true;

    # Sound
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };

  security.rtkit.enable = true;
}

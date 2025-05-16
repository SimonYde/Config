{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  inherit (lib) mkDefault mkIf;
in
{

  imports = [
    ./base/theming/nixos.nix
    ./nixos
    ./nixos/development.nix
  ];

  home-manager.users.${username}.imports = [ ./home-manager/gui ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
    ];

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };

  console = {
    useXkbConfig = true;
    font = "ter-i24n";
    packages = [ pkgs.terminus_font ];
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

  users.users.${username}.extraGroups = [
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

  networking = {
    useDHCP = mkDefault true;

    firewall = {
      enable = true;

      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
      ];

      trustedInterfaces = [ "tailscale0" ];
    };

    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
      wifi.powersave = false;
    };
  };

  hardware = {
    bluetooth = {
      enable = mkDefault true;
      settings.General.Experimental = true;
    };

    steam-hardware.enable = true;
    uinput.enable = true;

    enableAllHardware = true;

    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  services = {
    udisks2.enable = true;

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

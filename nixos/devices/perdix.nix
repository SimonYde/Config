{ pkgs, config, lib, ... }:

{
  imports = [
    ../modules/desktops/sway.nix
    ../modules/desktops/i3.nix
    ../modules/pc.nix
    ../modules/hardware/laptop.nix
    ../modules/hardware/graphics/nvidia.nix
    ../modules/hardware/graphics/amd.nix
    ../../home-manager/modules/themes.nix
  ];

  syde.laptop.enable = true;
  programs.sway.enable = true;
  services.xserver.windowManager.i3.enable = false;

  networking.hostName = "perdix";
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = false;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];
      privateKeyFile = "/home/syde/.secrets/wireguard.key";
      peers = [
        {
          # proton DK#25
          publicKey = "sbjnjFtxUz4dxYfNL7WOVf1StMjjAhkiPLCPtVtlhRI=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "193.29.107.162:51820";
        }
      ];
    };
  };

  environment.sessionVariables = with config.themes; {
    GTK_THEME = if prefer-dark then gtk.darkTheme else gtk.lightTheme;
    TERMINAL = "alacritty";
  };

  # services.geoclue2.enable = true;

  environment.systemPackages = with pkgs; [
    gparted
  ];
}

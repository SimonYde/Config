{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../modules/desktops/sway.nix
    ../modules/desktops/i3.nix
    ../modules/gaming.nix
    ../modules/pc.nix
    ../modules/hardware/laptop.nix
    ../modules/hardware/graphics/nvidia.nix
    ../modules/hardware/graphics/amd.nix
  ];

  syde = {
    laptop.enable = true;
    gaming.enable = true;
  };

  powerManagement.cpuFreqGovernor = "ondemand";

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

  environment.sessionVariables = {
    TERMINAL = "alacritty";
  };

  # services.geoclue2.enable = true;

  environment.systemPackages = with pkgs; [
    gparted
  ];
}

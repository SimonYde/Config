{ config, lib, ... }:

let
  cfg = config.networking.wireguard;
in
{
  config = lib.mkIf cfg.enable {
    networking.wg-quick.interfaces = {
      campfire = {
        autostart = false;
        configFile = "/var/lib/wireguard/campfire.conf";
      };
      proton = {
        autostart = false;
        address = [ "10.2.0.2/32" ];
        dns = [ "10.2.0.1" ];
        privateKeyFile = config.age.secrets.wireguard.path;

        peers = [
          {
            publicKey = "Vwqy4HMGPvkGaZXyYTNFUBJ8M5Qyo+d/ia+J4Np3Azk=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "149.88.109.34:51820";
          }
        ];
      };
    };
  };
}

{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.networking.wireguard.enable {
    networking.wg-quick.interfaces = {
      proton-wg = {
        autostart = false;
        address = [ "10.2.0.2/32" ];
        dns = [ "10.2.0.1" ];
        privateKeyFile = config.age.secrets.wireguard.path;
        peers = [
          {
            publicKey = "XPVCz7LndzqWe7y3+WSo51hvNOX8nX5CTwVTWhzg8g8=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "149.88.27.234:51820";
          }
        ];
      };
    };
  };
}

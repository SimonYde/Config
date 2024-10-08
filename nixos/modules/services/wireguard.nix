{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.networking.wireguard.enable {
    networking.wg-quick.interfaces = {
      proton-DK25 = {
        autostart = false;
        address = [ "10.2.0.2/32" ];
        dns = [ "10.2.0.1" ];
        privateKeyFile = config.age.secrets.wireguard.path;
        peers = [
          {
            publicKey = "sbjnjFtxUz4dxYfNL7WOVf1StMjjAhkiPLCPtVtlhRI=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "193.29.107.162:51820";
          }
        ];
      };
    };
  };
}

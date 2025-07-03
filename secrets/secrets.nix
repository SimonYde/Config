let
  keys = import ../keys.nix;
  users = with keys; [
    perdix
    icarus
  ];
in
{
  "wireguard.age".publicKeys = users;
  "pc-password.age".publicKeys = users;
  "rclone.age".publicKeys = users;
  "dns.age".publicKeys = users;
  "nextcloudAdminPassword.age".publicKeys = users;
  "vaultwarden.age".publicKeys = users;
}

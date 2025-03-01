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
  "tailscale.age".publicKeys = users;
}

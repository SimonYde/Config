let
  perdix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnb1qdH5rrSbY90rRA+tSzODZR+EhHEUuhnweZ2dn4X";
  icarus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyr6c70rH4SW5SVf3faR0z2DNGpFbfQ3B3/8qS+pgLV";
  users = [
    perdix
    icarus
  ];
in
{
  "wireguard.age".publicKeys = users;
}

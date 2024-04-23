{ lib, ... }:
{
  services.tailscale = {
    extraUpFlags = [ "--ssh" ];
  };
}

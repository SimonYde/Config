{ lib, ... }:
{
  programs.helix = {
    defaultEditor = false;
    settings = lib.mkForce { }; # NOTE: This is here so stylix does not mess with my settings
  };
}

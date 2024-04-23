{ ... }:
{
  # NOTE: Only works if udisks2 is installed e.g. `services.udisks2.enable = true;` on NixOS
  services.udiskie = {
    automount = true;
    notify = true;
  };
}

{ config, ... }:

{
  services.smartd = {
    enable = true;
    defaults.autodetected = "-a -o on -S on -s (S/../.././02|L/../../6/03) -n standby,q";
    notifications = {
      wall = {
        enable = true;
      };
      mail = {
        enable = true;
        sender = config.syde.email.fromAddress;
        recipient = config.syde.email.toAddress;
      };
    };
  };
}

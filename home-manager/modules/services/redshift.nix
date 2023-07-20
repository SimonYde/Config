{...}:
{
  services.redshift = {
    temperature = {
      day   = 6500;
      night = 1400;
    };
    provider  = "manual";
    latitude  = 56.3;
    longitude = 9.5;
  };
}

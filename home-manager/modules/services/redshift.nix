{config, ...}: let
  gammastep = config.services.gammastep;
in {
  services.redshift = {
    temperature = {
      day = gammastep.temperature.day;
      night = gammastep.temperature.night;
    };
    provider = "manual";
    latitude = gammastep.latitude;
    longitude = gammastep.longitude;
  };
}

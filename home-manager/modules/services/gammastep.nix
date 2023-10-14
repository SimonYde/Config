{...}: 

{
  services.gammastep = {
    temperature = {
      day   = 6500;
      night = 1400;
    };
    # provider  = "geoclue2";
    latitude  = 56.3;
    longitude = 9.5;
  };
}

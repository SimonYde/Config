{...}: {
  services.gammastep = {
    temperature = {
      day = 6500;
      # night = 1400;
      night = 2400;
    };
    duskTime = "18:45-20:30";
    dawnTime = "6:00-7:45";
    # provider  = "geoclue2";
    latitude = 56.3;
    longitude = 9.5;
  };
}

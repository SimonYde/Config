{ ... }:
{
  services.gammastep = {
    temperature = {
      day = 6500;
      # night = 1900;
      night = 2500;
    };
    tray = true;
    # duskTime = "18:45-20:30";
    # dawnTime = "6:00-7:45";
    # provider  = "geoclue2";
    latitude = 56.3;
    longitude = 9.5;
    settings = {
      general = {
        fade = 1;
        brightness-night = 0.8;
      };
    };
  };
}

{ ... }:

{
  config.security = {
    doas = {
      enable = true;
      extraRules = [
        { /* persist = true; */ noPass = true; groups = [ "wheel" ]; keepEnv = true; cmd = "nvim"; }
      ];
    };
  };   
}

{ ... }:

{
  config.security = {
    doas = {
      enable = true;
      extraRules = [
        { persist = true; groups = [ "wheel" ]; keepEnv = true; cmd = "nvim"; }
      ];
    };
  };   
}

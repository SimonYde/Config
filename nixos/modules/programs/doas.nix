{ ... }:

{
  config.security = {
    doas = {
      enable = true;
      extraRules = [
        { persist = true; nopass = true; groups = [ "wheel" ]; keepEnv = true; cmd = "nvim"; }
      ];
    };
  };   
}

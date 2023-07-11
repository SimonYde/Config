{ ... }:

{
  config.security = {
    doas = {
      enable = true;
      extraRules = [
        { persist = true; groups = [ "wheels" ]; keepEnv = true; cmd = "nvim"; }
      ];
    };
  };   
}

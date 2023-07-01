{ ... }:

{
  config.security = {
    doas = {
      enable = true;
      extraRules = [
        { groups = [ "wheels" ]; keepEnv = true; cmd = "nvim"; }
      ];
    };
  };   
}

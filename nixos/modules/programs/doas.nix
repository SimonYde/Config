{...}: {
  config.security.doas = {
    extraRules = [
      {
        persist = true;
        /*
        noPass = true;
        */
        groups = ["wheel"];
        keepEnv = true;
        cmd = "nvim";
      }
    ];
  };
}

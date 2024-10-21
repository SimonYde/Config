{ config, ... }:
{
  programs.nushell = {
    configFile.text = # nu
      ''
        let $config = {
          show_banner: false,
        }
      '';
  };
}

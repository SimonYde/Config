{ pkgs, ... }:
{
  programs = {
    zellij.enable = true;
  };
  
  home.packages = with pkgs; [
    speedtest-cli    
  ];
}

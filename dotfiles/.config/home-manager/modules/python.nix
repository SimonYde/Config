{ config, pkgs, ... }:

{
  config.home.packages = with pkgs; [
    (python3.withPackages(ps: with ps; [
      ipykernel
      pip
      numpy
      sympy
      matplotlib      
      flask
      nbconvert
      jupyter
      mypy
      pylsp-mypy
      autopep8
      # Stuff from venv for obsidian
      # contourpy
      cycler        
      fonttools       
      kiwisolver      
      packaging       
      pillow          
      pyparsing       
      python-dateutil 
      setuptools      
      six             
      wheel           
    ]))
  ];   
}


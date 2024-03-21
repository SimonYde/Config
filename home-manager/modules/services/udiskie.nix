{ ... }: 

{ 
  services.udiskie = {
    automount = true;
    notify = true;
  };
}

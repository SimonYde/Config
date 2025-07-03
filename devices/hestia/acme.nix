{
  users.groups.acme = { };

  security.acme.certs."certs.tmcs.dk" = {
    email = "s@tmcs.dk";
    extraDomainNames = [
      "edgeos.ts.tmcs.dk"
      "cloud.tmcs.dk"
      "password.tmcs.dk"
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@simonyde.com";
  };
}

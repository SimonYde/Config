{ ... }:
{
  services.ollama = {
    acceleration = "cuda";
    openFirewall = true;
    host = "[::]";
    loadModels = [
      "mistral"
      "llama3.1"
    ];
  };
}

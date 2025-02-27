{ ... }:
{
  services.ollama = {
    openFirewall = true;
    host = "[::]";
    loadModels = [
      "mistral"
      "llama3.1"
    ];
  };
}

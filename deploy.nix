{ inputs, self, ... }:
{
  flake.deploy.nodes = {
    kulich = {
      hostname = "wohlrath.cz";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs
      };
    };
  };
}

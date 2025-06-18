{ inputs, self, ... }:
{
  flake.deploy.nodes = {
    kulich = {
      hostname = "wohlrath.cz";
      profiles.system = {
        sshUser = "root";
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.kulich;
        remoteBuild = true;
      };
    };
  };
}

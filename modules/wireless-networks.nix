{ flake, config, ... }:

{
  imports = [
    flake.nixosModules.agenix
  ];

  age.secrets.wireless-networks.file = flake.secrets.wireless-networks;

  networking.wireless = {
    environmentFile = config.age.secrets.wireless-networks.path;
    networks = {
      "ISENGARD".psk = "@ISENGARD@";
    };
  };
}

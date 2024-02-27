{ flake, config, ... }:

{
  age.secrets.wireless-networks.file = flake.inputs.secrets.wireless-networks;

  networking.wireless = {
    environmentFile = config.age.secrets.wireless-networks.path;
    networks = {
      "ISENGARD".psk = "@ISENGARD@";
      "Winternet-1234".psk = "@WINTERNET@";
    };
  };
}

{ config, ... }:

{
  age.secrets.wireless-networks.file = ../secrets/wireless-networks.age;

  networking.wireless = {
    environmentFile = config.age.secrets.wireless-networks.path;
    networks = {
      "ISENGARD".psk = "@ISENGARD@";
    };
  };
}

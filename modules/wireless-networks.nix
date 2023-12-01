{ flake, config, ... }:

{
  age.secrets.wireless-networks.file = flake.lib.mkSecret "wireless-networks";

  networking.wireless = {
    environmentFile = config.age.secrets.wireless-networks.path;
    networks = {
      "ISENGARD".psk = "@ISENGARD@";
    };
  };
}

{ self, config, ... }:

{
  age.secrets.wireless-networks.file = self.mylib.mkSecret "wireless-networks";

  networking.wireless = {
    environmentFile = config.age.secrets.wireless-networks.path;
    networks = {
      "ISENGARD".psk = "@ISENGARD@";
    };
  };
}

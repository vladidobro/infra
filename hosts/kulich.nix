{ flake, config, pkgs, ... }:

{
  imports = [
    flake.nixosModules.vpsfree
  ];

  system.stateVersion = "23.11";

  time.timeZone = "Europe/Prague";

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  #users.extraUsers.root.openssh.authorizedKeys.keys =
  #  [ "..." ];

  virtualisation.docker.enable = true;



}

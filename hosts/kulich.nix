{ config, pkgs, ... }:
{
  imports = [
    ../modules/vpsadminos.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    hello
    neovim
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  #users.extraUsers.root.openssh.authorizedKeys.keys =
  #  [ "..." ];

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = "23.11";
}

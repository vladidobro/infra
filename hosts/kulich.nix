{ flake, config, pkgs, ... }:

{
  imports = [
    flake.nixosModules.vpsfree
    flake.inputs.home.nixosModules.home-manager
    flake.inputs.mailserver.nixosModule
  ];

  system.stateVersion = "23.11";

  time.timeZone = "Europe/Prague";

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit flake; };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    587
    993
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  #users.extraUsers.root.openssh.authorizedKeys.keys =
  #  [ "..." ];

  virtualisation.docker.enable = true;

  mailserver = {
    enable = true;
    fqdn = "mail.wohlrath.cz";
    domains = [ "wohlrath.cz" ];
    certificateScheme = "acme-nginx";

    loginAccounts = {
      "" = {
        hashedPasswordFile = "/root/passwd";
        aliases = [
        ];
      };
    };
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin+acme";

  services.nginx = {
    virtualHosts = {
      "www.wohlrath.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "wohlrath.cz" ];
        locations."/" = {
          root = "/var/www/";
        };
      };
    };
  };

  users.users.vladidobro = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  home-manager.users.vladidobro = flake.hmModules.nvim;

  users.users.daniel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}

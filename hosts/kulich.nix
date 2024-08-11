{ config, pkgs, lib, ... }:

{
  system.stateVersion = "23.11";

  time.timeZone = "UTC";

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

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
  };

  services.roundcube = {
    enable = true;
    hostName = "mail.wohlrath.cz";
    extraConfig = ''
      # starttls needed for authentication, so the fqdn required to match
      # the certificate
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  # services.radicale = {
  #   enable = true;
  #   config =
  #   let mailAccounts = config.mailserver.loginAccounts;
  #       htpasswd = with lib; pkgs.writeText "radicale.users" (concatStrings
  #         (flip mapAttrsToList mailAccounts (mail: user:
  #           mail + ":" + user.hashedPassword + "\n"
  #         ))  # there is no user.hashedPassword, only hashedPasswordFile
  #       );
  #   in ''
  #     [auth]
  #     type = htpasswd
  #     htpasswd_filename = ${htpasswd}
  #     htpasswd_encryption = bcrypt
  #   '';
  # };

  security.acme.acceptTerms = true;

  services.nginx = {
    virtualHosts = {
      "vladislav.wohlrath.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.vladislav.wohlrath.cz" ];
        locations."/" = {
          root = "/var/www/html";
        };
      };
      "wohlrath.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.wohlrath.cz" ];
        locations."/" = {
          root = "/var/www";
        };
      };
      "dav.wohlrath.cz" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:5232/";
          extraConfig = ''
            proxy_set_header  X-Script-Name /;
            proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass_header Authorization;
          '';
        };
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "data" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  users.users.daniel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users.vladidobro = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  home-manager.users.vladidobro = {
    imports = [ ../home ];

    vladidobro = {
      aliases = true;
      nvim.nixvim = true;
    };

    home.stateVersion = "23.11";

    home.username = "vladidobro";
    home.homeDirectory = "/home/vladidobro";
  };

  services.kulich-api.enable = true;

}

{ flake, config, pkgs, lib, ... }:

{
  imports = [
    flake.nixosModules.vpsfree
    flake.inputs.home.nixosModules.home-manager
    flake.inputs.mailserver.nixosModule
  ];

  system.stateVersion = "23.11";

  time.timeZone = "UTC";

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
      "${flake.inputs.secrets.mail.main}" = {
        hashedPasswordFile = "/root/passwd";
        aliases = [
        ];
      };
      "${flake.inputs.secrets.mail.srv}" = {
        hashedPasswordFile = "/root/passwd";
        aliases = [
        ];
      };
    };
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
  security.acme.defaults.email = flake.inputs.secrets.mail.acme;

  services.nginx = {
    virtualHosts = {
      "vladislav.wohlrath.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.vladislav.wohlrath.cz" ];
        locations."/" = {
          root = "${flake.inputs.homepage.packages.x86_64-linux.default}/html";
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

  users.users.vladidobro = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  home-manager.users.vladidobro = flake.hmModules.kulich;

  users.users.daniel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}

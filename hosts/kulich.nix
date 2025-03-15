{ config, pkgs, pkgs-unstable, lib, homepage, ... }:

{
  system.stateVersion = "23.11";

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  time.timeZone = "UTC";

  networking.firewall.allowedTCPPorts = [
    80
    443
    587  # SMPT
    993  # IMAP
    8998 # temporary
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

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
        root = "${homepage.packages.x86_64-linux.default}/html/";
        extraConfig = ''
          index index.html;
        '';
      };
      "wohlrath.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.wohlrath.cz" ];
        locations."/" = {
          root = "/var/www/wohlrath.cz";
        };
      };
      "martina.wohlrath.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.martina.wohlrath.cz" ];
        locations."/" = {
          root = "/var/www/martina.wohlrath.cz";
        };
      };
      "daniel.wohlrath.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.daniel.wohlrath.cz" ];
        locations."/" = {
          root = "/var/www/daniel.wohlrath.cz";
        };
      };
      "rea.wohlrath.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.rea.wohlrath.cz" ];
        locations."/" = {
          root = "/var/www/rea.wohlrath.cz";
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
      "grafana.wohlrath.cz" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "data" ];
    ensureUsers = [
      { name = "kulich-api"; }
      { name = "vladidobro"; }
    ];
    authentication = lib.mkOverride 10 ''
      # type database DBUser optional_identmap
      local all all peer map=usermap
    '';
    identMap = ''
      # arbitraryMapName systemUser DBUser
      usermap      root       postgres
      usermap      postgres   postgres
      usermap      vladidobro postgres
      usermap      /^(.*)$    \1
    '';
  };

  services.redis.servers.redis = {
    enable = true;
  };

  services.mongodb = {
    enable = true;
    package = pkgs-unstable.mongodb-ce;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  users.users.daniel = {
    isNormalUser = true;
    extraGroups = [ "podman" ];
  };

  users.users.martina = {
    isNormalUser = true;
    extraGroups = [ ];
  };

  users.users.rea = {
    isNormalUser = true;
    extraGroups = [ ];
  };

  users.users.pesa = {
    isNormalUser = true;
    extraGroups = [ "podman" ];
  };

  users.users.vladidobro = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  home-manager.users.vladidobro = {
    imports = [ ../home ];

    vladidobro = {
      enable = true;
      minimal = true;
      basic = true;
      aliases = true;
      nvim.enable = true;
    };

    home.stateVersion = "23.11";

    home.username = "vladidobro";
    home.homeDirectory = "/home/vladidobro";
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3050;
        domain = "grafana.wohlrath.cz";
        serve_from_sub_path = true;
      };
    };
  };

  services.kulich-api.enable = false;  # TODO

  services.svatba = {
    enable = true;   
    backendHost = "api.svatba.maskova.wohlrath.cz";
    frontendHost = "svatba.maskova.wohlrath.cz";
    mongoUri = "mongodb://127.0.0.1:27017/svatba";
  };

  environment.systemPackages = with pkgs; [
    mongosh
  ];
}

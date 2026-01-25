{ inputs, self, ... }: 
let 
  nixpkgs = inputs.nixpkgs-2511;
  home-manager = inputs.home-manager-2511;
  nixos-mailserver = inputs.nixos-mailserver-2511;

  config = { config, pkgs, lib, ... }: {
    system.stateVersion = "23.11";

    imports = [
      inputs.secrets.kulich
      home-manager.nixosModules.home-manager
      nixos-mailserver.nixosModules.default
      inputs.svatba.nixosModules.default
      self.nixosModules.vpsfree
    ];

    # === System ===

    time.timeZone = "UTC";
    nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
      registry = {
        nixpkgs.flake = nixpkgs;
      };
    };
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "yes";

    # === Mailserver ===

    mailserver = {
      enable = true;
      stateVersion = 3;
      fqdn = "mail.wohlrath.cz";
      domains = [ "wohlrath.cz" ];
      certificateScheme = "acme-nginx";
    };

    services.roundcube = {
      enable = true;
      hostName = "mail.wohlrath.cz";
      # https://github.com/roundcube/roundcubemail/wiki/Configuration
      extraConfig = ''
        $config['default_host'] = "ssl://${config.mailserver.fqdn}:993";
        $config['default_port'] = "993";
        $config['smtp_host'] = "ssl://${config.mailserver.fqdn}:465";
        $config['smtp_user'] = "%u";
        $config['smtp_pass'] = "%p";
      '';
    };

    
    # === Web ===

    security.acme.acceptTerms = true;

    services.nginx = {
      virtualHosts = {
        "pantombolar.cz" = {
          forceSSL = true;
          enableACME = true;
          serverAliases = [ "www.pantombolar.cz" ];
          root = pkgs.callPackage ../lib/http/pantombolar.cz {}; 
          extraConfig = ''
            try_files $uri $uri/ /index.html;
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
      };
    };

    services.svatba = {
      enable = true;   
      backendHost = "api.svatba.maskova.wohlrath.cz";
      frontendHost = "svatba.maskova.wohlrath.cz";
      mongoUri = "mongodb://127.0.0.1:27017/svatba";
    };

    # === Databases ===

    services.postgresql = {
      enable = true;
      authentication = lib.mkOverride 10 
      # type database DBUser optional_identmap
      ''
        local all all peer map=usermap
      '';
      identMap = 
      # mapName systemUser DBUser
      ''
        usermap   root       postgres
        usermap   postgres   postgres
        usermap   vladidobro postgres
        usermap   /^(.*)$    \1
      '';
    };

    services.mongodb = {
      enable = true;
      package = 
      let pkgs = import inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
      in pkgs.mongodb-ce;
    };



    # === Packages ===

    environment.systemPackages = with pkgs; [
      mongosh
    ];

    # === Users ===

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
    home-manager.sharedModules = [
      self.homeModules.default
    ];

    users.users.vladidobro = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
    home-manager.users.vladidobro = {
      home.stateVersion = "23.11";
      home.username = "vladidobro";
      home.homeDirectory = "/home/vladidobro";
      vladidobro = {
        enable = true;
        minimal = true;
        basic = true;
        aliases = true;
        nvim.enable = true;
      };
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
  };

in { 
  flake.nixosConfigurations.kulich = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ config ];
  };
}

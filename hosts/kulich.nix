{ inputs, self, ... }: 
let 

  config = { config, pkgs, lib, ... }: {
    system.stateVersion = "23.11";

    imports = [
      inputs.secrets.kulich
      inputs.home-manager-2511.nixosModules.home-manager
      inputs.nixos-mailserver-2511.nixosModules.default
      inputs.svatba.nixosModules.default
      self.nixosModules.vpsfree
    ];

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
      extraConfig = ''
        $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
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

    # === Users ===

    environment.systemPackages = with pkgs; [
      mongosh
    ];

    home-manager.sharedModules = [
      self.homeModules.default
    ];
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };

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
  flake.nixosConfigurations.kulich = inputs.nixpkgs-2511.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ config ];
  };
}

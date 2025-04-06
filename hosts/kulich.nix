{ inputs, self, ... }: 
let 

  home = {
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

  vpsfree = { config, pkgs, lib, ... }:
  with lib; let nameservers = [ "1.1.1.1" "2606:4700:4700::1111" ];
  in {
    networking.nameservers = mkDefault nameservers;
    services.resolved = mkDefault { fallbackDns = nameservers; };
    networking.dhcpcd.extraConfig = "noipv4ll";

    systemd.services.systemd-sysctl.enable = false;
    systemd.services.systemd-oomd.enable = false;
    systemd.sockets."systemd-journald-audit".enable = false;
    systemd.mounts = [ {where = "/sys/kernel/debug"; enable = false;} ];
    systemd.services.rpc-gssd.enable = false;

    # Due to our restrictions in /sys, the default systemd-udev-trigger fails
    # on accessing PCI devices, etc. Override it to match only network devices.
    # In addition, boot.isContainer prevents systemd-udev-trigger.service from
    # being enabled at all, so add it explicitly.
    systemd.additionalUpstreamSystemUnits = [
      "systemd-udev-trigger.service"
    ];
    systemd.services.systemd-udev-trigger.serviceConfig.ExecStart = [
      ""
      "-udevadm trigger --subsystem-match=net --action=add"
    ];

    boot.isContainer = true;
    boot.enableContainers = mkDefault true;
    boot.loader.initScript.enable = true;
    boot.specialFileSystems."/run/keys".fsType = mkForce "tmpfs";
    boot.systemdExecutable = mkDefault "/run/current-system/systemd/lib/systemd/systemd systemd.unified_cgroup_hierarchy=0";

    # Overrides for <nixpkgs/nixos/modules/virtualisation/container-config.nix>
    documentation.enable = mkOverride 500 true;
    documentation.nixos.enable = mkOverride 500 true;
    networking.useHostResolvConf = mkOverride 500 false;
    services.openssh.startWhenNeeded = mkOverride 500 false;

    # Bring up the network, /ifcfg.{add,del} are supplied by the vpsAdminOS host
    systemd.services.networking-setup = {
      description = "Load network configuration provided by the vpsAdminOS host";
      before = [ "network.target" ];
      wantedBy = [ "network.target" ];
      after = [ "network-pre.target" ];
      path = [ pkgs.iproute2 ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash /ifcfg.add";
        ExecStop = "${pkgs.bash}/bin/bash /ifcfg.del";
      };
      unitConfig.ConditionPathExists = "/ifcfg.add";
      restartIfChanged = false;
    };
  };

  config = { config, pkgs, lib, ... }: {
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
          root = "${inputs.homepage.packages.x86_64-linux.default}/html/";
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
      package = 
      let pkgs = import inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
      in pkgs.mongodb-ce;
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

    services.svatba = {
      enable = true;   
      backendHost = "api.svatba.maskova.wohlrath.cz";
      frontendHost = "svatba.maskova.wohlrath.cz";
      mongoUri = "mongodb://127.0.0.1:27017/svatba";
      dashboard = {
        enable = true;
        host = "widgets.svatba.maskova.wohlrath.cz";
        mongoUri = "mongodb://127.0.0.1:27017/svatba";
      };
    };

    environment.systemPackages = with pkgs; [
      mongosh
    ];

    home-manager.users.vladidobro = home;

    imports = [
      inputs.secrets.kulich
      inputs.home-manager-2405.nixosModules.home-manager
      inputs.agenix-2405.nixosModules.default
      inputs.nixos-mailserver-2405.nixosModules.default
      inputs.svatba.nixosModules.default
      inputs.svatba-dashboard.nixosModules.default
    ];

    home-manager.sharedModules = [
      self.homeModules.default
    ];
  };

in { 
  flake.nixosConfigurations.kulich = inputs.nixpkgs-2405.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ config vpsfree ];
  };
}

{ config, pkgs, lib, ... }:

with lib;
let 
  cfg = config.services.kulich-api;
  pkg = pkgs.callPackage ./. {};
in {
  options.services.kulich-api = {
    enable = mkEnableOption "kulich-api";
    hostname = mkOption {
      type = types.str;
      default = "api.wohlrath.cz";
    };
    port = mkOption {
      type = types.int;
      default = 8088;
    };
    user = mkOption {
      type = types.str;
      default = "kulich-api";
    };
  };

  config = {
    systemd.services.kulich-api = mkIf cfg.enable {
      enable = true;
      serviceConfig = {
        ExecStart = "${pkg}/bin/kulich-api -p ${builtins.toString cfg.port}";
        User = cfg.user;
        # TODO other options
      };
    };

    users.users.${cfg.user} = mkIf cfg.enable {
      group = cfg.user;
      isSystemUser = true;
      createHome = false;
    };
    users.groups.${cfg.user} = mkIf cfg.enable {};
    
    services.nginx.virtualHosts = mkIf cfg.enable {
      "${cfg.hostname}" = {
        forceSSL = mkDefault true;
        enableACME = mkDefault true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}/";
          extraConfig = ''
            proxy_set_header  X-Script-Name /;
            proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass_header Authorization;
          '';
        };
      };
    };
  };
}

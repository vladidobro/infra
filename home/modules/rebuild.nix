{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.vladidobro;
  c = cfg.rebuild;
  platform = pkgs.stdenv.hostPlatform;
in {
  options.vladidobro = {
    rebuild = {
      enable = mkEnableOption "rebuild";
      path = mkOption {
        type = types.path;
        default = "/etc/nixos";
      };
      hostname = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = mkIf (cfg.enable && c.enable) {
    home.packages = 
    let
      rebuild = pkgs.writeShellScriptBin "rebuild" ''
        case "$1" in
          "")
            ${if platform.isLinux then "nixos-rebuild" else if platform.isDarwin then "darwin-rebuild" else if platform.isAndroid then "nix-on-droid" else ""} switch \
              --flake git+file:${c.path}#${c.hostname}
            ;;
          "kulich")
            nixos-rebuild switch \
              --flake git+file:${c.path}#kulich \
              --fast --build-host root@kulich --target-host root@kulich
            ;;
          *)
            echo "Unknown host: $1"
            echo "Choose one of: kulich"
            exit 1
            ;;
        esac
      '';
    in [ rebuild ];
  };
}

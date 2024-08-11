{ config, pkgs, lib, ... }:

with lib;
let cfg = config.kulich-api;
{
  options.kulich-api = {
    enable = mkEnableOption "kulich-api";
    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
    };
    port = mkOption {
      type = types.int;
      default = 8080;
    };
  };

  config = {
    environment.packages = [ (pkgs.callPackage ./. {}) ];
  };
}

{ config, pkgs, lib, ... }:

with lib;
let cfg = config.programs.duckdb;
in {
  options.programs.duckdb = {
    enable = mkEnableOption "duckdb";
    #config = mkOption {
    #  type = types.str;
    #};
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ duckdb ];
  };
}

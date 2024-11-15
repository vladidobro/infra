{ config, pkgs, lib, ... }:

with lib;
let cfg = config.programs.ipython;
in {
  options.programs.ipython = {
    enable = mkEnableOption "ipython";
    #config = mkOption {
    #  type = types.str;
    #};
  };

  config = mkIf cfg.enable {

  };
}

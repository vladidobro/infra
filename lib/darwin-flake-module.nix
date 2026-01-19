{ lib, ... }:
let
  inherit (lib) 
    mkOption 
    types
    ;
in
{
  options = {
    flake.darwinConfigurations = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      description = ''
        Instantiated nix-darwin configurations. Used by `darwin-rebuild`.
      '';
    };
  };
}

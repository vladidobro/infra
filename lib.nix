{
  # nixPath = [{nixpkgs = <drv>}]
  mkNixRegistry = flakes: { nix.registry = builtins.mapAttrs (name: value: { flake = value; }) flakes; };
  mkHomeShared = modules: { home-manager.sharedModules = modules; };
  mkOverlayModule = overlays: { nixpkgs = { inherit overlays; }; };
}

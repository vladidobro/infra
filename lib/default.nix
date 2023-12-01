{ flake, nixpkgs }:

rec {
  mkOverlaysModule = overlays: { nixpkgs = { inherit overlays; } };

  mkSecret = name: flake.secrets + ("/" + name + ".age");

  mkUserModule = name:
  { self, config, ... }:
  {
    
  };

  mkNixosSystem = {specialArgs ? {}, ... }@attrs: 
    nixpkgs.lib.nixosSystem ({ specialArgs = ({ inherit flake; } // specialArgs); } // attrs);
}

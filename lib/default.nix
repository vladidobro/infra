{ flake, nixpkgs }:

rec {
  mkOverlaysModule = overlays: { nixpkgs = { inherit overlays; }; };

  mkSecret = name: flake.secrets + ("/" + name + ".age");

  mkUserModule = name:
  { self, config, ... }:
  {
    
  };

  addSpecialArgsFlake = fn: {specialArgs ? {}, ... }@attrs: 
    fn ({ specialArgs = ({ inherit flake; } // specialArgs); } // attrs);

  mkNixosSystem = addSpecialArgsFlake nixpkgs.lib.nixosSystem;
}

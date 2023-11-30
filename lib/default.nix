rec {
  mkOverlaysModule = overlays: { nixpkgs.overlays = overlays; };

  mkSecret = name: ../secrets + ("/" + name + ".age");

  mkUserModule = name:
  { self, config, ... }:
  {
    
  };
}

{ self, nixpkgs, darwin, wsl, droid, home, ... }@flake-inputs:

let
  lib = nixpkgs.lib;
  flake = self;
in rec {
  addSpecialArgsFlake = argname: fn: attrs: 
    let 
      passedSpecialArgs = if lib.hasAttr argname attrs then lib.getAttr argname attrs else {};
      extraSpecialArgs = { inherit flake flake-inputs; };
      fullArgs = attrs // { "${argname}" = extraSpecialArgs // passedSpecialArgs; };
    in fn fullArgs;
  mkNixos = addSpecialArgsFlake "specialArgs" nixpkgs.lib.nixosSystem;
  mkHome = addSpecialArgsFlake "extraSpecialArgs" home.lib.homeManagerConfiguration;
  mkDarwin = addSpecialArgsFlake "specialArgs" darwin.lib.darwinSystem;
  mkDroid = addSpecialArgsFlake "specialArgs" droid.lib.nixOnDroidConfiguration;
}

{ self, nixpkgs, darwin, wsl, droid, home, ... }@inputs:

let
  lib = nixpkgs.lib;
in rec {
  addSpecialArgsFlake = argname: fn: attrs: 
    let 
      passedSpecialArgs = if lib.hasAttr argname attrs then lib.getAttr argname attrs else {};
      extraSpecialArgs = { flake = self; };
      fullArgs = attrs // { "${argname}" = extraSpecialArgs // passedSpecialArgs; };
    in fn fullArgs;
  mkNixos = addSpecialArgsFlake "specialArgs" nixpkgs.lib.nixosSystem;
  mkHome = addSpecialArgsFlake "extraSpecialArgs" home.lib.homeManagerConfiguration;
  mkDarwin = addSpecialArgsFlake "specialArgs" darwin.lib.darwinSystem;
  mkDroid = addSpecialArgsFlake "specialArgs" droid.lib.nixOnDroidConfiguration;
}

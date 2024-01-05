{ self, nixpkgs, darwin, wsl, droid, home, nix, ... }@flake-inputs:

let
  lib = nixpkgs.lib;
  flake = self;
in rec {
  mkOverlaysModule = overlays: { nixpkgs = { inherit overlays; }; };

  mkUserModule = {name, home ? null }:
  {
    users.users."${name}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    home-manager.users."${name}" = home;
  };

  addSpecialArgsFlake = argname: fn: attrs: 
    let 
      passedSpecialArgs = if lib.hasAttr argname attrs then lib.getAttr argname attrs else {};
      extraSpecialArgs = { inherit flake flake-inputs; };
      fullArgs = attrs // { "${argname}" = extraSpecialArgs // passedSpecialArgs; };
    in fn fullArgs;
  mkNixosSystem = addSpecialArgsFlake "specialArgs" nixpkgs.lib.nixosSystem;
  mkHomeManagerConfiguration = addSpecialArgsFlake "extraSpecialArgs" home.lib.homeManagerConfiguration;
  mkDarwinSystem = addSpecialArgsFlake "specialArgs" darwin.lib.darwinSystem;
  mkNixOnDroidConfiguration = addSpecialArgsFlake "specialArgs" droid.lib.nixOnDroidConfiguration;
}

{ self, nixpkgs, home-manager, ... }@flake-inputs:

let
  flake = self;
in rec {
  mkOverlaysModule = overlays: { nixpkgs = { inherit overlays; }; };

  mkUserModule = {name, home-config ? null }:
  {
    users.users."${name}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    home-manager.users."${name}" = home-config;
  };

  addSpecialArgsFlake = argname: fn: {"${argname}" ? {}, ... }@attrs: 
    let 
      attrs-argname = if nixpkgs.lib.hasAttr "${argnanme}" attrs then attrs."${argname}" else {};
    in 
      fn (
        attrs // 
	{
	  "${argname}" = (
	    { inherit flake flake-inputs; } // attrs."${argname}"
	  ); 
	}
      );

  mkNixosSystem = addSpecialArgsFlake "specialArgs" nixpkgs.lib.nixosSystem;

  mkHomeManagerConfiguration = addSpecialArgsFlake "extraSpecialArgs" home-manager.lib.homeManagerConfiguration;
}

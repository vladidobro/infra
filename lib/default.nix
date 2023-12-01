{ flake, nixpkgs }:

rec {
  mkOverlaysModule = overlays: { nixpkgs = { inherit overlays; }; };

  mkSecret = name: flake.secrets + ("/" + name + ".age");

  mkUserModule = {name, home-config ? null }:
  {
    users.users."${name}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    home-manager.users."${name}" = home-config;
  };

  addSpecialArgsFlake = fn: {specialArgs ? {}, ... }@attrs: 
    fn ({ specialArgs = ({ inherit flake; } // specialArgs); } // attrs);

  mkNixosSystem = addSpecialArgsFlake nixpkgs.lib.nixosSystem;
}

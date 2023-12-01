{ flake-inputs, ... }:

{
  imports = [
    flake-inputs.home-manager.nixosModules.default
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}

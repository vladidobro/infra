{ flake-inputs, ... }:

{
  imports = [
    flake-inputs.home.nixosModules.default
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}

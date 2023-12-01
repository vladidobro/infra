{ flake-inputs, ... }:

{
  imports = [
    flake-inputs.home-manager.nixosModules.default
  ];
}

{ flake, config, ... }:

{
  imports = [
    flake.nixosModules.droid;
  ];
}

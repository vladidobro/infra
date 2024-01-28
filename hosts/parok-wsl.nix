{ flake, config, ... }:

{
  imports = [
    flake.nixosModules.wsl
  ];
}

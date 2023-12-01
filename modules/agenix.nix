{ flake-inputs, ... }:

{
  imports = [
    flake-inputs.agenix.nixosModules.default
  ];
}

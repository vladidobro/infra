{ inputs, ... }:
with inputs;
{
  imports = [
    ./kulich.nix
    ./sf.nix
    ./parok.nix
    ./myskus.nix
  ];
}

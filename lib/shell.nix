{ inputs, self, ... }:

{
  perSystem = { config, pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [ 
        nixos-rebuild 
      ];
    };
  };
}

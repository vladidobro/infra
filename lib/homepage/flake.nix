{
  description = "vladidobro homepage";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOs";
      repo = "nixpkgs";
      ref = "nixpkgs-unstable";
    };
    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages."${system}";
    in with pkgs; {
      packages.default = stdenv.mkDerivation {
        name = "homepage";
        src = ./.;
        buildInputs = [ hugo go ];
        buildPhase = ''
          hugo
        '';
        installPhase = ''
          mkdir -p $out/html
          cp -a public/. $out/html
        '';
      };

      devShells.default = mkShell {
        buildInputs = [ hugo go ];
      };
    }
  );
}

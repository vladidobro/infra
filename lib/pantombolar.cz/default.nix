{
  buildNpmPackage,
  ...
}:

  
buildNpmPackage rec {
  pname = "pantombolar.cz";
  version = "0.1.0";
  src = ./.;

  npmDepsHash = "sha256-tAyyFmytZlbXF5nULS6mhdruLxhjdP1YiU/n9rLGZYs=";
  installPhase = ''
    mkdir -p $out
    cp -a dist/. $out
  '';
}


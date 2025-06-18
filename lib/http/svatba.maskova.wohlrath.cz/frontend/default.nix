backendHost:

{
  lib,
  buildNpmPackage,
  ...
}:

  
buildNpmPackage rec {
  pname = "svatba-frontend";
  version = "0.1.0";
  src = ./.;

  VITE_API_HOST = backendHost;
  npmDepsHash = "sha256-GJVZwygSwWztjHFfbz/Qulj+eCXg7vgSuqe9xYzPvsg=";
  installPhase = ''
    mkdir -p $out
    cp -a dist/. $out
  '';
}

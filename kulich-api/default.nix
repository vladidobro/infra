{
  rustPlatform,
  lib
}:

rustPlatform.buildRustPackage {
  pname = "kulich-api";
  version = "0.0.1";
  src = lib.cleanSource ./.;
  cargoLock.lockFile = ./Cargo.lock;
}

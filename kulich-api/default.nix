{
  rustPlatform,
  lib
}:

let manifest = (lib.importTOML ./Cargo.toml).package;
in rustPlatform.buildRustPackage {
  pname = "kulich-api";
  version = "0.0.1";
  src = ./.;
  cargoHash = "sha256-IpGDu4HBZGzSBM5mwN4fDfiXMTA9zyGpb6ABrKp2/Ak=";
  doCheck = false;
}

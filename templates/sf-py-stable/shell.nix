let 
  system = if builtins.currentSystem == "aarch64-darwin" 
    then "x86_64-darwin" else builtins.currentSystem;
  # system = builtins.currentSystem
in { pkgs ? import <nixpkgs> { inherit system; } }:
let
  # python = pkgs.python310;
  python = (import <python>).packages."${system}"."3.10.13";
in pkgs.mkShell {
  packages = with pkgs; [
    (poetry.override { python3 = python; })
    (python.withPackages (ps: with ps; [ pip ]))
    azure-cli
    libcxx
    libiodbc
  ];
}

{ pkgs, ... }:

let
  lsps = with pkgs; {
    bash = nodePackages.bash-language-server;
    haskell = haskellPackages.haskell-language-server;

    json = nodePackages.vscode-json-languageserver;
    python = python311Packages.python-lsp-server;
    latex = texlab;
    toml = taplo;
    markdown = marksman;
    yaml = yaml-language-server;
    dhall = dhall-lsp-server;
    dockerfile = dockerfile-language-server-nodejs;
    nix = nil;
    rust = rust-analyzer;
   };
in {
  home.packages = with pkgs; [
    python311Packages.poetry
    cargo
    rustc
  ] ++ builtins.attrValues lsps;
}

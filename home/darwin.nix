{ flake, config, pkgs, ... }:

{
  imports = [
    ./modules/minimal.nix
    ./modules/home.nix
    ./modules/sf.nix
    ./modules/nvim
    ./modules/macos.nix
  ];

  home.stateVersion = "23.11";

  home = {
    username = "vladislavwohlrath";
    homeDirectory = "/Users/vladislavwohlrath";
  };

  home.shellAliases = {
    e = "nvim";
    rebuild = "darwin-rebuild switch --flake git+file:/etc/nixos#darwin";
    deploy-kulich = "nixos-rebuild switch --fast --flake git+file:/etc/nixos#kulich --build-host root@kulich --target-host root@kulich";

    v = ". ~/venv/bin/activate";
    V = "deactivate";
    vpy = "sh -c \". ~/venv/bin/activate; ipython";
    t = "nix flake init --template";
  };


  programs.ssh.extraConfig = ''
    Host kulich
        User vladidobro
        HostName 37.205.14.94
        IdentityFile ~/.ssh/id_private

    Host oci
        User opc
        HostName 10.127.96.17
        IdentityFile ~/.ssh/id_rastaoci

    Host github.com
        IdentityFile ~/.ssh/id_private

    Host *
        IdentityFile ~/.ssh/id_rsa
  '';

  home.packages = with pkgs; [
    nixos-rebuild
    qemu
    cachix

    nodePackages_latest.pyright
    poetry
    (python3.withPackages (ps: with ps; [ pip ]))
    ruff

    cargo
    rust-analyzer
    dhall
    cabal-install
    (haskellPackages.ghcWithPackages (pkgs: with pkgs; [ sdl2 ]))
    SDL2
    SDL2.dev
    haskellPackages.haskell-language-server
  ];
}

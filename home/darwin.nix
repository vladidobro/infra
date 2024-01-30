{ flake, config, pkgs, ... }:

{
  imports = [
    ./modules/minimal.nix
    ./modules/home.nix
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
    t = "nix flake init --template";
  };

  programs.zsh.initExtra = ''
    function legacy-init-arm () {
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PYENV_ROOT=~/.pyenv
        export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/opt/openssl/lib/
        eval "$(pyenv init -)"
    }

    function legacy-init-x86 () {
        eval "$(/usr/local/bin/brew shellenv)"
        export PYENV_ROOT=~/.pyenv_x86
        export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl@1.1/lib/
        eval "$(/usr/local/bin/pyenv init -)"
    }

    alias x="legacy-init-arm"
    alias xx="legacy-init-arm; legacy-init-x86"
  '';

  programs.ssh.extraConfig = ''
    Host data
        User vladislav.wohlrath@second-foundation.eu
        HostName 10.254.67.6

    Host kulich
        User vladislav
        HostName 37.205.14.94
        IdentityFile ~/.ssh/id_private

    Host github.com
        IdentityFile ~/.ssh/id_private

    Host *
        IdentityFile ~/.ssh/id_rsa
  '';

  home.packages = with pkgs; [
    nixos-rebuild
    qemu

    nodePackages_latest.pyright
    poetry
    (python3.withPackages (ps: with ps; [ pip ]))

    rust-analyzer
  ];
}

{ flake, config, pkgs, ... }:

{
  imports = [
    ./modules/minimal.nix
    ./modules/home.nix
  ];

  home.username = "vladislavwohlrath";
  home.homeDirectory = "/Users/vladislavwohlrath";

  home.stateVersion = "23.11";

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

    alias init="legacy-init-arm"
    alias x="legacy-init-arm; legacy-init-x86"
  '';

  programs.ssh.extraConfig = ''
    Host data
        User vladislav.wohlrath@second-foundation.eu
        HostName 10.254.67.6

    Host kulich
        HostName 37.205.14.94
        IdentityFile ~/.ssh/id_private

    Host github.com
        IdentityFile ~/.ssh/id_private

    Host *
        IdentityFile ~/.ssh/id_rsa
  '';
}

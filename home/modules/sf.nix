{ flake, config, pkgs, ... }:

{
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
    alias X="legacy-init-x86"
    alias xx="legacy-init-arm; legacy-init-x86"

    function kv () {
        az keyvault secret show --id "https://kv-commo-$1-weu-data.vault.azure.net/secrets/$2" -o json | jq --raw-output0 '.value'
    }
  '';

  programs.ssh.extraConfig = ''
    Host data
        User ${flake.inputs.secrets.mail.sf}
        HostName 10.254.67.6
  '';

  home.packages = with pkgs; [
    azure-cli
    azure-storage-azcopy
    k9s
    kubelogin
    glab
    argocd
  ];

  programs.git = {
    userName = "Vladislav Wohlrath";
    userEmail = flake.inputs.secrets.mail.sf;

    ignores = [ ".envrc" ".direnv" "shell.nix" ];
    extraConfig = {
      init.defaultBranch = "main";
      pager.branch = false;
      push.autoSetupRemote = true;
      push.default = "current";
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_rsa";
      commit.gpgsign = true;
    };
  };
}

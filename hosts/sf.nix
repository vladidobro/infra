{ pkgs, ... }: 

{
  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings.trusted-users = [ "vladislavwohlrath" ];
    settings.experimental-features = [ "nix-command" "flakes" ];

    linux-builder.enable = true;
    buildMachines = [
      {
        sshUser = "root";
        hostName = "wohlrath.cz";
        protocol = "ssh";
        system = "x86_64-linux";
        maxJobs = 8;
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU9MMFNQUjlZTDJWL1FxTjFCZEttOURuL3JxbXVLWmFVSG50cUwwVWZEVUYgcm9vdEBuaXhvcwo=";
        sshKey = "/users/vladislavwohlrath/.ssh/id_private";
      }
    ];

    # nixPath = [
    #   { nixpkgs = flake.inputs.nixpkgs; }
    #   { python = flake.inputs.python; }
    #   { sys = flake; }
    # ];
    # registry = {
    #   nixpkgs.flake = flake.inputs.nixpkgs;
    #   python.flake = flake.inputs.python;
    #   sys.flake = flake;
    # };

  };


  nixpkgs.config.allowUnfree = true;

  programs.bash.enable = true;
  programs.zsh.enable = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  users.users.vladislavwohlrath.home = "/Users/vladislavwohlrath";
  home-manager.users.vladislavwohlrath = { pkgs, ... }: {
    imports = [ ../home ];

    home.stateVersion = "23.11";

    home.username = "vladislavwohlrath";
    home.homeDirectory = "/Users/vladislavwohlrath";


    vladidobro = {
      enable = true;
      aliases = true;
      minimal = true;
      basic = true;
      full = true;
      develop = {
        enable = true;
        c = true;
        python = true;
        rust = true;
        haskell = true;
      };
      graphical = true;

      nvim.enable = true;
      nvim.nixvim = true;

      rebuild = {
        enable = true;
        hostname = "sf";
      };
    };

    home.shellAliases = {
      v = ". ~/venv/bin/activate";
      V = "deactivate";
    };


    home.packages = with pkgs; [
      (pkgs.writeShellScriptBin "sf" ''exec "/users/vladislavwohlrath/src/lib/sf/.venv/bin/sf" "$@"'')
      nixos-rebuild
      qemu
      podman
      colima
      inetutils
      qmk
      renameutils
      cmake
      gnumake
      meson
      ninja

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

      azure-cli
      azure-storage-azcopy
      k9s
      kubelogin
      glab
      argocd
    ];

    programs.ssh.matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_rsa";
      };
      "kulich" = {
        user = "vladidobro";
        hostname = "wohlrath.cz";
        identityFile = "~/.ssh/id_private";
      };
      "github.com" = {
        identityFile = "~/.ssh/id_private";
      };
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
      alias X="legacy-init-x86"
      alias xx="legacy-init-arm; legacy-init-x86"
    '';

    programs.git.ignores = [ ".envrc" ".direnv" "shell.nix" ];

    programs.direnv.stdlib = ''
      use_rosetta() {
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PYENV_ROOT=~/.pyenv
        export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/opt/openssl/lib/
        eval "$(pyenv init -)"
        eval "$(/usr/local/bin/brew shellenv)"
        export PYENV_ROOT=~/.pyenv_x86
        export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl@1.1/lib/
        eval "$(/usr/local/bin/pyenv init -)"
      }
    '';
  };
}

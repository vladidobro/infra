{ inputs, ... }:
let home = { pkgs, ... }: {
  imports = [ ../home ];

  home.stateVersion = "23.11";

  home.username = "vladislavwohlrath";
  home.homeDirectory = "/Users/vladislavwohlrath";


  # comon configuration
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
    nvim.nixvim = {
      enable = true;
      alias = "nixvim";
    };

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
    # utils
    nixos-rebuild
    qemu
    podman
    colima
    inetutils
    renameutils
    gnumake
    ninja
    duckdb

    # meteo tools
    cdo
    eccodes

    # python
    nodePackages_latest.pyright
    poetry
    (python3.withPackages (ps: with ps; [ pip ]))
    ruff

    # languages
    cargo
    rust-analyzer
    dhall
    cabal-install
    zig
    kotlin
    gradle
    openjdk
    maturin

    # integration
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

  # don't pollute common git projects
  programs.git.ignores = [ ".envrc" ".direnv" ];

  # setup homebrew
  programs.zsh.initExtra = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/opt/openssl/lib/
  '';
};
config = { pkgs, ... }: {
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
  nixpkgs.overlays = [ inputs.nixvim.overlays.default ];

  programs.bash.enable = true;
  programs.zsh.enable = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  homebrew = {
    enable = true;
    brews = [
      "azure-cli"
      "libiodbc"
    ];
  };

  users.users.vladislavwohlrath.home = "/Users/vladislavwohlrath";
  home-manager.users.vladislavwohlrath = home;

  home-manager.sharedModules = [
    inputs.nix-index-database.hmModules.nix-index 
    inputs.nixvim.homeManagerModules.nixvim
  ];

  imports = [
    inputs.secrets.sf
    inputs.home-manager.darwinModules.home-manager
  ];
};
in {
  flake.darwinConfigurations.sf = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [ config ];
  };
}

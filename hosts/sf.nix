{ inputs, self, ... }:
let 
  nixpkgs = inputs.nixpkgs-2505;
  nix-darwin = inputs.nix-darwin-2505;
  nixvim = inputs.nixvim-2505;
  nix-index-database = inputs.nix-index-database-2505;
  home-manager = inputs.home-manager-2505;

  home = { pkgs, ... }: 
  {
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
      nvim.nixvim = {
        enable = true;
        alias = "nixvim";
      };
    };

    home.sessionPath = [
      "$HOME/.local/bin"
    ];

    home.shellAliases = {
      v = ". ~/venv/bin/activate";
      V = "deactivate";
    };

    home.packages = with pkgs; [
      nixos-rebuild
      qemu
      inetutils
      renameutils
      gnumake
      pyright
      poetry
      (python3.withPackages (ps: with ps; [ pip ]))
      ruff
    ];

    programs.ssh.matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
      };
      "kulich" = {
        user = "vladidobro";
        hostname = "wohlrath.cz";
        identityFile = "~/.ssh/id_private";
      };
      "wohlrath.cz" = {
        identityFile = "~/.ssh/id_private";
      };
      "github.com" = {
        identityFile = "~/.ssh/id_private";
      };
    };

    programs.git.ignores = [ ".envrc" ".direnv" ];

    programs.zsh.initContent = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/opt/openssl/lib/
    '';
  };

  config = { pkgs, ... }: {
    imports = [
      inputs.secrets.sf
      home-manager.darwinModules.home-manager
    ];

    system.stateVersion = 4;
    system.primaryUser = "vladislavwohlrath";
    ids.gids.nixbld = 350;  # nix was installed when this was default

    nixpkgs.hostPlatform = "aarch64-darwin";
    #services.nix-daemon.enable = true;
    nix = {
      enable = true;
      package = pkgs.nix;
      settings.trusted-users = [ "vladislavwohlrath" ];
      settings.experimental-features = [ "nix-command" "flakes" ];

      #linux-builder.enable = true;
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
      registry = {
        nixpkgs.flake = nixpkgs;
      };
    };
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [ nixvim.overlays.default ];

    programs.bash.enable = true;
    programs.zsh.enable = true;

    homebrew = {
      enable = true;
      brews = [
      ];
    };

    users.users.vladislavwohlrath.home = "/Users/vladislavwohlrath";

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
    home-manager.sharedModules = [
      nix-index-database.homeModules.nix-index 
      nixvim.homeManagerModules.nixvim
      self.homeModules.default
    ];
    home-manager.users.vladislavwohlrath = home;
  };

in {
  flake.darwinConfigurations.sf = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [ config ];
  };
}

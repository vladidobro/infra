{ inputs, self, ... }:
let 
  nixpkgs = inputs.nixpkgs-2511;
  nix-darwin = inputs.nix-darwin-2511;
  home-manager = inputs.home-manager-2511;
  nixvim = inputs.nixvim-2511;
  secrets = inputs.secrets.sf;


  config = { pkgs, ... }: {
    system.stateVersion = 6;  # 25.11

    imports = [
      home-manager.darwinModules.home-manager
      secrets
    ];

    # === System ===

    system.primaryUser = "vladislavwohlrath";
    nixpkgs.hostPlatform = "aarch64-darwin";
    nixpkgs.config.allowUnfree = true;
    nix = {
      settings.trusted-users = [ "vladislavwohlrath" ];
      settings.experimental-features = [ "nix-command" "flakes" ];
      registry = {
        nixpkgs.flake = nixpkgs;
      };
    };
    fonts.packages = with pkgs; [ nerd-fonts.noto ];

    # === Packages ===

    programs.bash.enable = true;
    programs.zsh.enable = true;
    programs.zsh.shellInit = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    homebrew = {
      enable = true;
      brews = [
        "pipx"
        "azure-cli"
        "kubectl"
        "kubelogin"
        "colima"
        "uv"
        "k9s"
        "argocd"
        "glab"
        #"msodbcsql18"
      ];
    };
    environment.systemPackages = with pkgs; [ 
      git
      tmux
      neovim
    ];

    # === Users ===
    
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
    home-manager.sharedModules = [
      nixvim.homeModules.nixvim
      self.homeModules.default
    ];

    users.users.vladislavwohlrath.home = "/Users/vladislavwohlrath";
    home-manager.users.vladislavwohlrath = { pkgs, ... }:
    {
      home.stateVersion = "25.11";
      home.username = "vladislavwohlrath";
      home.homeDirectory = "/Users/vladislavwohlrath";

      vladidobro = {
        enable = true;
        aliases = true;
        minimal = true;
        basic = true;
        full = true;
        graphical = true;
        nvim.enable = false;
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
      ];

      programs.ssh.enableDefaultConfig = false;
      programs.ssh.matchBlocks = {
        "*" = {
          forwardAgent = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          compression = false;
          addKeysToAgent = "no";
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
          identityFile = "~/.ssh/id_ed25519";
        };
        "kulich" = {
          user = "vladidobro";
          hostname = "wohlrath.cz";
        };
      };

      programs.git.ignores = [ ".envrc" ".direnv" ];
      programs.git.settings = {
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519";
        commit.gpgsign = true;
      };

      programs.nixvim.enable = true;
      programs.nixvim.imports = [ self.nixvimModules.default ];
    };
  };

in {
  flake.darwinConfigurations.sf = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [ config ];
  };
}

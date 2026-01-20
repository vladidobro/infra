{ inputs, self, ... }:
let 
  nixpkgs = inputs.nixpkgs-2511;
  nix-darwin = inputs.nix-darwin-2511;
  home-manager = inputs.home-manager-2511;
  nixvim = inputs.nixvim-2511;

  home = { pkgs, ... }: 
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
      #qemu
      #inetutils
      #renameutils
      #pyright
      #poetry
      #(python3.withPackages (ps: with ps; [ pip ]))
      #ruff
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

  config = { pkgs, ... }: {
    imports = [
      home-manager.darwinModules.home-manager
    ];

    system.stateVersion = 6;  # 25.11
    nixpkgs.hostPlatform = "aarch64-darwin";
    nixpkgs.config.allowUnfree = true;

    fonts.packages = with pkgs; [
      nerd-fonts.noto
    ];
    system.primaryUser = "vladislavwohlrath";
    nix = {
      settings.trusted-users = [ "vladislavwohlrath" ];
      settings.experimental-features = [ "nix-command" "flakes" ];
      registry = {
        nixpkgs.flake = nixpkgs;
      };
    };
    #nixpkgs.overlays = [ nixvim.overlays.default ];

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
      ];
    };

    users.users.vladislavwohlrath.home = "/Users/vladislavwohlrath";

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
    home-manager.sharedModules = [
      nixvim.homeModules.nixvim
      self.homeModules.default
    ];
    home-manager.users.vladislavwohlrath = home;

    environment.systemPackages = with pkgs; [ 
      vim
      git
    ];
  };

in {
  flake.darwinConfigurations.sf = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [ config inputs.secrets.sf ];
  };
}

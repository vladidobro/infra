{ flake, pkgs, ... }: 

{
  imports = [
    flake.inputs.home.darwinModules.home-manager
  ];

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";

  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    nixPath = [
      { nixpkgs = flake.inputs.nixpkgs; }
    ];
    registry = {
      nixpkgs.flake = flake.inputs.nixpkgs;
      sys.flake = flake;
    };
    #linux-builder.enable = true;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit flake; };
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;

  users.users.vladislavwohlrath.home = "/Users/vladislavwohlrath";
  home-manager.users.vladislavwohlrath = flake.hmModules.darwin;
}

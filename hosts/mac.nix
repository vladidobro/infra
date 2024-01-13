{ flake, pkgs, flake-inputs, ... }: 

{
  imports = [
    flake-inputs.home.darwinModules.home-manager
  ];


  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  users.users.vladislavwohlrath.home = "/Users/vladislavwohlrath";
  home-manager.users.vladislavwohlrath = import ../home/vladidobro/darwin.nix;
  home-manager.extraSpecialArgs = { inherit flake flake-inputs; };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;
}

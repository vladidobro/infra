{ flake, pkgs, ... }: 

{
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";


      services.nix-daemon.enable = true;
      nix.package = pkgs.nix;

      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;
}

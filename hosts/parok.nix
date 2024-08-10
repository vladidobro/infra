{ config, pkgs, ... }:

{
  system.stateVersion = "23.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  #services.nix-daemon.enable = true;  # no exist
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    #nixPath = [
    #  { nixpkgs = flake.inputs.nixpkgs; }
    #  { python = flake.inputs.python; }
    #  { sys = flake; }
    #];
    #registry = {
    #  nixpkgs.flake = flake.inputs.nixpkgs;
    #  python.flake = flake.inputs.python;
    #  sys.flake = flake;
    #};
  };

  networking = {
    hostName = "parok";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  time.timeZone = "Europe/Prague";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver = {
    enable = true;
    libinput.enable = true;
    xkb.layout = "us";
    xkb.options = "caps:escape";
    windowManager.xmonad.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.printing.enable = true;

  programs.zsh.enable = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  users.users.vladidobro = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  home-manager.users.vladidobro = {
    imports = [ ../home ];
  };
}

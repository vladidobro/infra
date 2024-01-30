{ flake, config, pkgs, ... }:

{
  imports = [
    flake.nixosModules.hardware.parok
    flake.nixosModules.wifi
    flake.inputs.home.nixosModules.home-manager
    flake.inputs.agenix.nixosModules.default
  ];


  system.stateVersion = "23.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.hostPlatform = "aarch64-darwin";
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    nixPath = [
      { nixpkgs = flake.inputs.nixpkgs; }
      { python = flake.inputs.python; }
      { sys = flake; }
    ];
    registry = {
      nixpkgs.flake = flake.inputs.nixpkgs;
      python.flake = flake.inputs.python;
      sys.flake = flake;
    };
  };

  networking = {
    hostName = "parok";
    wireless = {
      enable = true;
      userControlled.enable = true;
    };
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
    layout = "us";
    xkbOptions = "caps:escape";
    windowManager.xmonad.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.printing.enable = true;

  services.openssh.enable = true;

  programs.bash.enable = true;
  programs.zsh.enable = true;

  users.users.vladidobro = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  home-manager.users.vladidobro = flake.hmModules.parok;
}

{ inputs, ... }:
let home = {
  imports = [ ../home ];

  home.stateVersion = "23.11";

  home.username = "vladidobro";
  home.homeDirectory = "/home/vladidobro";
};
hardware = { config, lib, pkgs, modulesPath, ... }: {
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/299315fe-e8b5-4b5a-8b02-01ace801599f";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/299315fe-e8b5-4b5a-8b02-01ace801599f";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

  fileSystems."/home/data" =
    { device = "/dev/disk/by-uuid/299315fe-e8b5-4b5a-8b02-01ace801599f";
      fsType = "btrfs";
      options = [ "subvol=data" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/299315fe-e8b5-4b5a-8b02-01ace801599f";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/299315fe-e8b5-4b5a-8b02-01ace801599f";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/22D0-6931";
      fsType = "vfat";
    };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };
};
config = { config, pkgs, ... }: {
  system.stateVersion = "23.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  #services.nix-daemon.enable = true;  # no exist
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
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
  home-manager.users.vladidobro = home;

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.default
  ];
};
in {
  flake.nixosConfigurations.parok = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ hardware config ];
    };
}

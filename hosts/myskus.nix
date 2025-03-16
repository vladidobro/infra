{ inputs, self, ... }:
let 

  home = {
    home.stateVersion = "24.11";

    home.username = "vladidobro";
    home.homeDirectory = "/home/vladidobro";

    vladidobro = {
      enable = true;
      aliases = true;
      minimal = true;
      basic = true;
      full = true;
      graphical = true;
      nvim.enable = true;
    };
  };

  hardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/9a83adb1-000f-430d-9385-69b14b3cda5d";
        fsType = "btrfs";
        options = [ "subvol=root" "compress=zstd" ];
      };

    fileSystems."/home" =
      { device = "/dev/disk/by-uuid/9a83adb1-000f-430d-9385-69b14b3cda5d";
        fsType = "btrfs";
        options = [ "subvol=home" "compress=zstd" ];
      };

    fileSystems."/data" =
      { device = "/dev/disk/by-uuid/9a83adb1-000f-430d-9385-69b14b3cda5d";
        fsType = "btrfs";
        options = [ "subvol=data" "compress=zstd" ];
      };

    fileSystems."/nix" =
      { device = "/dev/disk/by-uuid/9a83adb1-000f-430d-9385-69b14b3cda5d";
        fsType = "btrfs";
        options = [ "subvol=nix" "compress=zstd" "noatime" ];
      };

    fileSystems."/swap" =
      { device = "/dev/disk/by-uuid/9a83adb1-000f-430d-9385-69b14b3cda5d";
        fsType = "btrfs";
        options = [ "subvol=swap" "noatime" ];
      };

    fileSystems."/boot/efi" =
      { device = "/dev/disk/by-uuid/E86E-A363";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };

    swapDevices = [ { device = "/swap/swapfile"; } ];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    services.printing.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    services.libinput.enable = true;

    hardware.graphics.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    environment.systemPackages = with pkgs; [
      clinfo
    ];
  };

  config = { config, lib, pkgs, ... }: {
    system.stateVersion = "24.11";

    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.device = "nodev";
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";

    nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };

    networking = {
      hostName = "myskus";
      networkmanager.enable = true;
      firewall = {
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
      };
    };

    time.timeZone = "Europe/Prague";

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = lib.mkDefault "us";
      useXkbConfig = true;
    };

    services.xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.options = "caps:escape";
      windowManager.xmonad.enable = true;
    };

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Noto" ]; })
    ];

    services.openssh.enable = true;

    programs.zsh.enable = true;
    environment.systemPackages = with pkgs; [
      git
      tmux
      neovim
    ];

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
      inputs.home-manager-2411.nixosModules.home-manager
    ];

    home-manager.sharedModules = [
      self.homeModules.default
    ];
  };

in {
  flake.nixosConfigurations.myskus = inputs.nixpkgs-2411.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ hardware config ];
  };
}

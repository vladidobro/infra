{ inputs, self, ... }:
let 
  nixpkgs = inputs.nixpkgs-2511;
  home-manager = inputs.home-manager-2511;
  nixvim = inputs.nixvim-2511;

  config = { config, lib, pkgs, modulesPath, ... }: {
    system.stateVersion = "24.11";

    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      home-manager.nixosModules.home-manager
    ];

    # === Hardware ===

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];
    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.device = "nodev";
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    fileSystems = {
      "/" = { 
        device = "/dev/disk/by-uuid/9a83adb1-000f-430d-9385-69b14b3cda5d";
        fsType = "btrfs";
        options = [ "subvol=root" "compress=zstd" ];
      };
      "/home" = { 
        device = "/dev/disk/by-uuid/9a83adb1-000f-430d-9385-69b14b3cda5d";
        fsType = "btrfs";
        options = [ "subvol=home" "compress=zstd" ];
      };
      "/data" = { 
        device = "/dev/disk/by-uuid/9a83adb1-000f-430d-9385-69b14b3cda5d";
        fsType = "btrfs";
        options = [ "subvol=data" "compress=zstd" ];
      };
      "/nix" = { 
        device = "/dev/disk/by-uuid/9a83adb1-000f-430d-9385-69b14b3cda5d";
        fsType = "btrfs";
        options = [ "subvol=nix" "compress=zstd" "noatime" ];
      };
      "/swap" = { 
        device = "/dev/disk/by-uuid/9a83adb1-000f-430d-9385-69b14b3cda5d";
        fsType = "btrfs";
        options = [ "subvol=swap" "noatime" ];
      };
      "/boot/efi" = { 
        device = "/dev/disk/by-uuid/E86E-A363";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };
    };
    swapDevices = [ { device = "/swap/swapfile"; } ];
    networking.useDHCP = true;
    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
    services.printing.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
    services.libinput.enable = true;
    hardware.graphics.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
    networking = {
      hostName = "myskus";
      networkmanager.enable = true;
      firewall = {
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
      };
    };

    # === System ===

    time.timeZone = "Europe/Prague";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
      useXkbConfig = true;
    };
    nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
      registry = {
        nixpkgs.flake = nixpkgs;
      };
    };
    services.openssh.enable = true;
    services.xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.options = "caps:escape";
      windowManager.xmonad.enable = true;
    };
    fonts.packages = with pkgs; [ nerd-fonts.noto ];

    # === Packages ===

    programs.bash.enable = true;
    programs.zsh.enable = true;
    environment.systemPackages = with pkgs; [
      clinfo  # OpenCL info
      git
      tmux
      neovim
    ];

    # === Users ===

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      sharedModules = [
        nixvim.homeModules.nixvim
        self.homeModules.default
      ];
    };

    users.users.vladidobro = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
    home-manager.users.vladidobro = {
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

      programs.nixvim.enable = true;
      programs.nixvim.imports = [ self.nixvimModules.default ];
    };
  };

in {
  flake.nixosConfigurations.myskus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ config ];
  };
}

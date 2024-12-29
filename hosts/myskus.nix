{ config, lib, pkgs, ... }:

{
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
  home-manager.users.vladidobro = {
    imports = [ ../home ];

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
}

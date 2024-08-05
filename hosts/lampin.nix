{ pkgs, config, ... }:

{
  environment.packages = with pkgs; [
    vim
    git
    openssh
  ];
  
  system.stateVersion = "24.05";
  android-integration = {
   termux-setup-storage.enable = true;
  };

  home-manager = {
    config = {
      imports = [ ../home ];
      vladidobro.features = {
        basic = true;
      };
    };
  };
}

{ flake, config, pkgs, ... }:

{
  nixpkgs.overlays = [ flake.overlays.nushell ];

  home.username = "vladidobro";
  home.homeDirectory = "/home/vladidobro";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    tmux
    ripgrep
    brave
    dmenu-rs
    alacritty
    lf
    transmission-qt
    styx
  ];

  programs.git = {
    enable = true;
    userName = "Vladislav Wohlrath";
    userEmail = "vladislav@wohlrath.cz";
  };

  programs.ssh = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs.nushell = {
    enable = true;
    package = pkgs.nushell-dfr;
  };

  programs.atuin = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.helix = {
    enable = true;
  };
}

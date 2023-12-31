{ flake, config, pkgs, ... }:

{
  home.username = "vladislavwohlrath";
  home.homeDirectory = "/Users/vladislavwohlrath";

  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    hello
    atuin
  ];
}

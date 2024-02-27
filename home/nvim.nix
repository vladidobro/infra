{ flake, config, pkgs, ... }:

{
  home.stateVersion = "23.11";

  home.username = "vladidobro";
  home.homeDirectory = "/home/vladidobro";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins [
      { plugin = nvim-tree-lua;
        config = ''
        -- nvim tree
        '';
        type = "lua";
      }
    ];
  };
}

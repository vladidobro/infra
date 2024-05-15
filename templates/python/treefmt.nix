{ pkgs, ... }:
{
  projectRootFile = "pyproject.toml";
  programs.ruff = {
    enable = true;
  };
}

Windows
-------

1. Clean install.
   1. Reject all telemetry.
   2. Uninstall everything possible and reduce the permissions of everything left.
   3. Turn off all startup programs.
   3. Remove everything from statusbar.
   4. Install Visual C++ Redistributable.
2. Install essentials.
   1. Install scoop.
      ```
      Set-ExecutionPolicy RemoteSigner -Scope CurrentUser
      irm get.scoop.sh | iex
      scoop bucket add extras
      ```
   2. Install browser.
      ```
      scoop install brave
      ```
   3. Install shell tools.
      ```
      scoop install nu
      scoop install git
      scoop install neovim
      scoop install helix
      ```
   4. Install window manager.
      ```
      scoop install whkd
      scoop install komorebi
      ```
3. Install WSL
   1. Install Ubuntu to update WSL
      ```
      wsl --install
      wsl -d Ubuntu
      ```
   2. Download and install NixOS-WSL
      ```
      wsl --import NixOS .\NixOS\ nixos-wsl.tar.gz --version 2
      wsl -s NixOS
      ```

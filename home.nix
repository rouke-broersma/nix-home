# ~/.config/home-manager/home.nix
{ lib, ... }:

let
  isWSL = builtins.getEnv "WSL_DISTRO_NAME" != "";
in
{
  imports = [ 
    ./common.nix
    ./zsh.nix
    ./git.nix
    ./docker.nix
  ] ++ lib.optional isWSL ./wsl.nix;
}

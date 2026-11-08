# ~/.config/home-manager/home.nix
{ lib, ... }:

let
  isWSL = builtins.pathExists "/proc/sys/kernel/osrelease" &&
          lib.strings.hasInfix "microsoft" (builtins.readFile "/proc/sys/kernel/osrelease");
in
{
  imports = [ 
    ./common.nix
    ./zsh.nix
    ./git.nix
    ./docker.nix
  ] ++ lib.optional isWSL ./wsl.nix;
}

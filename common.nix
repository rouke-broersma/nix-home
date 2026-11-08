# ~/.config/home-manager/common.nix
{ pkgs, ... }:

{
  home.username = "rouke";
  home.homeDirectory = "/home/rouke";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    curl
    wget
    openssh
    ripgrep
    fd
    jq
    yq-go
    kubectl
    kubernetes-helm
    kubectx
  ];

  home.shellAliases = {
    k = "kubectl";
    kctx = "kubectx";
    kn = "kubens";
  };

  home.sessionVariables = {
    EDITOR = "code --wait";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

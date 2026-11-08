# ~/.config/home-manager/wsl.nix
{ pkgs, ... }:

{
  home.sessionVariables = {
    # Routes xdg-open/CLI logins (az login, gh auth) directly to your default Windows browser
    BROWSER = "/mnt/c/Windows/System32/cmd.exe /c start";
  };

  home.packages = with pkgs; [
    wsl2-ssh-agent
  ];

  programs.zsh.initContent = ''
    eval $(wsl2-ssh-agent)
  '';
}

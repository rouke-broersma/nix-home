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
    if ! wsl_agent_init="$(wsl2-ssh-agent)" ||
       [[ -z "$wsl_agent_init" ]] ||
       ! eval "$wsl_agent_init"; then
      print -u2 "Failed to initialize the WSL SSH agent bridge."
    fi
    unset wsl_agent_init
  '';
}

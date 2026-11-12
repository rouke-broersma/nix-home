# ~/.config/home-manager/wsl.nix
{ ... }:

let
  skHelper = "/mnt/c/Windows/System32/OpenSSH/ssh-sk-helper.exe";
in
{
  home.sessionVariables = {
    # Routes xdg-open/CLI logins (az login, gh auth) directly to your default Windows browser
    BROWSER = "/mnt/c/Windows/System32/cmd.exe /c start";

    # https://developers.yubico.com/SSH/Securing_SSH_and_git_with_FIDO2_on_WSL2.html
    SSH_SK_HELPER = skHelper;
  };

  services.ssh-agent.enable = true;

  systemd.user.sessionVariables = {
    SSH_SK_HELPER = skHelper;
  };
}

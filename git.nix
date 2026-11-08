# ~/.config/home-manager/git.nix
{ ... }:

{  
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Rouke Broersma";
        email = "mobrockers@gmail.com";
        signingKey = "~/.ssh/id_ed25519_sk.pub";
        signByDefault = true;
      };
      gpg.format = "ssh";
      commit.gpgSign = true;
    };
  };
}

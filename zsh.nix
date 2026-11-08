# ~/.config/home-manager/zsh.nix
{ lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    initExtra = ''
      if [ -t 1 ] && [ -z "$ZSH_VERSION" ] && [ -x "$(command -v zsh)" ]; then
        exec zsh
      fi
    '';
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];

    initContent = lib.mkMerge [
      (lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      (lib.mkOrder 1000 ''
        setopt extended_glob
        setopt HIST_IGNORE_SPACE
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'

        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
      '')
    ];
  };

  home.file.".p10k.zsh".source = ./.p10k.zsh;
}

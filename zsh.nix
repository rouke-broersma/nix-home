# ~/.config/home-manager/zsh.nix
{ pkgs, ... }: 

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

    completionInit = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];

    # Raw Zsh Options (replaces setopt lines)
    initContent = ''
      # Native Zsh Options
      setopt extended_glob
      setopt HIST_IGNORE_SPACE

      # Load P10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${USER}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${USER}.zsh"
      fi

      # Source custom prompt config if present
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Keybindings for History Substring Search (Up / Down arrows)
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # Auto-bridge wsl2-ssh-agent socket
      if command -v wsl2-ssh-agent >/dev/null 2>&1; then
        eval $(wsl2-ssh-agent)
      fi
    '';
  };

  home.file.".p10k.zsh".source = ./.p10k.zsh;
}
